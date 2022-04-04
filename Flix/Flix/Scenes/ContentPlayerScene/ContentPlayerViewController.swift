//
//  
//  ContentPlayerViewController.swift
//  Flix
//
//  Created by Anton Romanov on 12.11.2021.
//
//

import AVFoundation
import UIKit
import AVKit

protocol ContentPlayerDisplayLogic: AnyObject {
    func playContent(_ viewModel: ContentPlayerModels.InitialData.ViewModel)
    func shouldLoadOrRenewRequestedResource(_ viewModel: ContentPlayerModels.AssetLoaderData.ViewModel)
    func didHappenAccessLogEvent(_ viewModel: ContentPlayerModels.LogEvent.ViewModel)
    func didHappenErrorLogEvent(_ viewModel: ContentPlayerModels.LogEvent.ViewModel)
}

final class ContentPlayerViewController: UIViewController {
    // MARK: - Outlets

    // MARK: - Properties
    var interactor: ContentPlayerBusinessLogic?
    var router: ContentPlayerRouterable?

    static let periodicTimeInterval = 0.5
    private var timeObserverToken: Any?
    private var statusObservationToken: NSKeyValueObservation?
    private var accessLogUpdateInterval = 20 / ContentPlayerViewController.periodicTimeInterval

    private let avPlayerViewController = AVPlayerViewController()
    private var player: AVPlayer? {
        return avPlayerViewController.player
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addPlayerVC()
        Task(priority: .utility) {
            let request = ContentPlayerModels.InitialData.Request()
            await interactor?.fetchURLToPlay(request)
        }
    }
}

// MARK: - Private methods
private extension ContentPlayerViewController {
    func addPlayerVC() {
        avPlayerViewController.view.backgroundColor = .black
        addChild(avPlayerViewController)
        avPlayerViewController.view.frame = view.bounds
        view.addSubview(avPlayerViewController.view)
        avPlayerViewController.didMove(toParent: self)
    }

    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(avPlayerItemNewAccessLogEntry), name: .AVPlayerItemNewAccessLogEntry, object: player?.currentItem)
        NotificationCenter.default.addObserver(self, selector: #selector(avPlayerItemNewErrorLogEntry), name: .AVPlayerItemNewErrorLogEntry, object: player?.currentItem)

        addPeriodicTimeObserver()
        statusObservationToken = player?.observe(\.currentItem?.status, options: [.old, .new, .initial], changeHandler: { [weak self] pl, changes in
            print("Status changed from \(String(describing: changes.oldValue)) to \(String(describing: changes.newValue))\n")

            if let currentPlayerStatus = pl.currentItem?.status {
                switch currentPlayerStatus {
                case .failed:
                    print("AVPlayerItem error: \(String(describing: pl.currentItem?.error?.localizedDescription))\n")
                    print("Error log: \(String(describing: pl.currentItem?.errorLog()))\n")
                    self?.router?.routeToErrorSceene()
                case .readyToPlay:
                    print("READY TO PLAY\n")
                    pl.play()
                case .unknown:
                    print("PLAYER STATUS IS UNKNOWN\n")
                @unknown default:
                    return
                }
            }
        })
    }

    func removePeriodicTimeObserver() {
        if timeObserverToken != nil {
            player?.removeTimeObserver(timeObserverToken as Any)
            timeObserverToken = nil
        }
    }
    func addPeriodicTimeObserver() {
        if timeObserverToken == nil {
            let interval = CMTime(seconds: ContentPlayerViewController.periodicTimeInterval, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
            timeObserverToken = player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] _ in
                self?.notifyAboutAccessLogEntryIfNeeded(self?.player?.currentItem)
            }
        }
    }

    @objc func avPlayerItemNewAccessLogEntry(notification: Notification) {
        guard let playerItem = notification.object as? AVPlayerItem else {
            return
        }
        let request = ContentPlayerModels.LogEvent.Request(playerItem: playerItem)
        interactor?.didHappenAccessLogEvent(request)
    }

    @objc func avPlayerItemNewErrorLogEntry(notification: Notification) {
        guard let playerItem = notification.object as? AVPlayerItem else {
            return
        }
        let request = ContentPlayerModels.LogEvent.Request(playerItem: playerItem)
        interactor?.didHappenErrorLogEvent(request)
    }

    func decrementAccessLogUpdateInterval(reset: Bool = false) {
        if reset {
            accessLogUpdateInterval = 20 / ContentPlayerViewController.periodicTimeInterval
        } else {
            accessLogUpdateInterval -= 1
        }
    }
    
    func notifyAboutAccessLogEntryIfNeeded(_ currentItem: AVPlayerItem?) {
        guard let playerItem = player?.currentItem else {
            return
        }
        if self.accessLogUpdateInterval == 0 {
            let request = ContentPlayerModels.LogEvent.Request(playerItem: playerItem)
            interactor?.didHappenAccessLogEvent(request)
            self.decrementAccessLogUpdateInterval(reset: true)
        } else {
            self.decrementAccessLogUpdateInterval()
        }
    }
}

// MARK: - Conforming to ContentPlayerDisplayLogic
extension ContentPlayerViewController: ContentPlayerDisplayLogic {
    func playContent(_ viewModel: ContentPlayerModels.InitialData.ViewModel) {
        let asset = AVURLAsset(url: viewModel.url)
        asset.resourceLoader.setDelegate(self, queue: DispatchQueue.global())
        let playerItem = AVPlayerItem(asset: asset)
        avPlayerViewController.player = AVPlayer(playerItem: playerItem)

        addObservers()
    }

    func shouldLoadOrRenewRequestedResource(_ viewModel: ContentPlayerModels.AssetLoaderData.ViewModel) {
    }

    func didHappenAccessLogEvent(_ viewModel: ContentPlayerModels.LogEvent.ViewModel) {
    }

    func didHappenErrorLogEvent(_ viewModel: ContentPlayerModels.LogEvent.ViewModel) {
    }
}

// MARK: - AVAssetResourceLoaderDelegate
extension ContentPlayerViewController: AVAssetResourceLoaderDelegate {
    public func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForRenewalOfRequestedResource renewalRequest: AVAssetResourceRenewalRequest) -> Bool {
        return shouldLoadOrRenewRequestedResource(resourceLoadingRequest: renewalRequest)
    }

    public func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        return shouldLoadOrRenewRequestedResource(resourceLoadingRequest: loadingRequest)
    }

    func shouldLoadOrRenewRequestedResource(resourceLoadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        let request = ContentPlayerModels.AssetLoaderData.Request(resourceLoadingRequest: resourceLoadingRequest)
        interactor?.shouldLoadOrRenewRequestedResource(request)

        return true
    }
}
