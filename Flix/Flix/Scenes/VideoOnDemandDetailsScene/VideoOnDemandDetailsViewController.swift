//
//  
//  VideoOnDemandDetailsViewController.swift
//  Flix
//
//  Created by Anton Romanov on 21.10.2021.
//
//

import UIKit

protocol VideoOnDemandDetailsDisplayLogic: AnyObject {
    func displayVideoOnDemandDetails(_ viewModel: VideoOnDemandDetailsModels.InitialData.ViewModel)
    func displayVideoOnDemandDetailsAction(_ viewModel: VideoOnDemandDetailsModels.Action.ViewModel)
    func displayContentPlayer(_ viewModel: VideoOnDemandDetailsModels.SelectVideoOnDemandDetailsAction.ViewModel)
    func displayMoreEpisodes(_ viewModel: VideoOnDemandDetailsModels.SelectVideoOnDemandDetailsAction.ViewModel)
    func displayRateContent(_ viewModel: VideoOnDemandDetailsModels.SelectVideoOnDemandDetailsAction.ViewModel)
    func displayWatchLater(_ viewModel: VideoOnDemandDetailsModels.SelectVideoOnDemandDetailsAction.ViewModel)
}

final class VideoOnDemandDetailsViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var containerView: UIView!
    
    @IBOutlet private weak var consumptionTimeLabel: UILabel!
    @IBOutlet private weak var consumptionTimeSeparatorView: UIView!
    @IBOutlet private weak var productionInfoLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var genresLabel: UILabel!
    @IBOutlet private weak var ratingView: UIView!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    // MARK: - Properties
    var interactor: VideoOnDemandDetailsBusinessLogic?
    var router: VideoOnDemandDetailsRouterable?

    private var actionOptionsDataSource: UICollectionViewDiffableDataSource<UUID, UUID>?
    private var actionOptionsCollectionView: UICollectionView?
    private var prefferedSceneTabIndexPath: IndexPath = IndexPath(item: 0, section: 0)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = VideoOnDemandDetailsModels.InitialData.Request()
        interactor?.fetchVideoOnDemandDetails(request)
    }
}

// MARK: - Private methods
private extension VideoOnDemandDetailsViewController {
    func configureHierarchy(_ layout: UICollectionViewLayout) {
        actionOptionsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        configureActionOptions(actionOptionsCollectionView)
    }

    // -> ActionOptions
    func configureActionOptions(_ collectionView: UICollectionView?) {
        guard let collectionView = collectionView  else {
            return
        }
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.remembersLastFocusedIndexPath = true
        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .clear

        containerView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 90),
            collectionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 90),
            collectionView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -90),
            collectionView.heightAnchor.constraint(equalToConstant: 84)
        ])
    }

    func configureActionOptionsDataSource(_ viewModel: VideoOnDemandDetailsModels.InitialData.ViewModel) {
        guard let collectionView = actionOptionsCollectionView else {
            print("\(String(describing: VideoOnDemandDetailsViewController.self)): Failed to get collection view.")
            return
        }
        let cellRegistration = UICollectionView.CellRegistration<VideoOnDemandDetailsActionCell, UUID> { [weak self] cell, indexPath, id in
            let request = VideoOnDemandDetailsModels.Action.Request(object: cell, indexPath: indexPath)
            self?.interactor?.fetchVideoOnDemandDetailsAction(request)
        }
        actionOptionsDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemID in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemID)
        })
        actionOptionsDataSource?.apply(viewModel.dataSourceSnapshot, animatingDifferences: false)
    }
    // <- ActionOptions
    func updateVideoOnDemandDetailssInfo(_ viewModel: VideoOnDemandDetailsModels.InitialData.ViewModel) {
        guard let videoOnDemandItem = viewModel.videoOnDemandItem else {
            return
        }
        if let posterName = videoOnDemandItem.poster {
            posterImageView.image = UIImage(named: posterName)
        }
        consumptionTimeLabel.text = videoOnDemandItem.consumptionTime
        consumptionTimeSeparatorView.isHidden = false
        titleLabel.text = videoOnDemandItem.title
        productionInfoLabel.attributedText = videoOnDemandItem.productionInfo
        genresLabel.text = videoOnDemandItem.genresInfo
        if let imbdRating = videoOnDemandItem.ratingInfo {
            ratingLabel.attributedText = imbdRating
            ratingView.isHidden = false
        }
        descriptionLabel.text = videoOnDemandItem.description
    }
}

// MARK: - Conforming to VideoOnDemandDetailsDisplayLogic
extension VideoOnDemandDetailsViewController: VideoOnDemandDetailsDisplayLogic {
    func displayVideoOnDemandDetails(_ viewModel: VideoOnDemandDetailsModels.InitialData.ViewModel) {
        updateVideoOnDemandDetailssInfo(viewModel)
        configureHierarchy(viewModel.layout)
        configureActionOptionsDataSource(viewModel)
    }

    func displayVideoOnDemandDetailsAction(_ viewModel: VideoOnDemandDetailsModels.Action.ViewModel) {
        guard let cell = viewModel.object as? VideoOnDemandDetailsActionCell else {
            return
        }
        cell.action = viewModel.action
    }

    func displayContentPlayer(_ viewModel: VideoOnDemandDetailsModels.SelectVideoOnDemandDetailsAction.ViewModel) {
        router?.routeToContentPlayer()
    }

    func displayMoreEpisodes(_ viewModel: VideoOnDemandDetailsModels.SelectVideoOnDemandDetailsAction.ViewModel) {
        router?.routeToMoreEpisodes()
    }

    func displayRateContent(_ viewModel: VideoOnDemandDetailsModels.SelectVideoOnDemandDetailsAction.ViewModel) {
        router?.routeToRateContent()
    }

    func displayWatchLater(_ viewModel: VideoOnDemandDetailsModels.SelectVideoOnDemandDetailsAction.ViewModel) {
        router?.routeToWatchLater()
    }
}

// MARK: - UICollectionViewDelegate
extension VideoOnDemandDetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let request = VideoOnDemandDetailsModels.SelectVideoOnDemandDetailsAction.Request(indexPath: indexPath)
        interactor?.didSelectVideoOnDemandDetailsAction(request)
    }
    func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {
        return prefferedSceneTabIndexPath
    }
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        prefferedSceneTabIndexPath = indexPath
        return true
    }
}
