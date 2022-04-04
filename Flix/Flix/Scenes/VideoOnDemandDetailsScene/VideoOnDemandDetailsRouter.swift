//
//  
//  VideoOnDemandDetailsRouter.swift
//  Flix
//
//  Created by Anton Romanov on 21.10.2021.
//
//

import UIKit

typealias VideoOnDemandDetailsRouterable = VideoOnDemandDetailsRoutingLogic & VideoOnDemandDetailsDataPassing

protocol VideoOnDemandDetailsRoutingLogic {
    func routeToError()
    func routeToMoreEpisodes()
    func routeToContentPlayer()
    func routeToRateContent()
    func routeToWatchLater()
}

protocol VideoOnDemandDetailsDataPassing {
    var dataStore: VideoOnDemandDetailsDataStore? { get }
}

final class VideoOnDemandDetailsRouter: VideoOnDemandDetailsRouterable {
    // MARK: - Properties
    weak var viewController: VideoOnDemandDetailsViewController?
    var dataStore: VideoOnDemandDetailsDataStore?

    lazy var transitionHelper = ControllerTransitionHelper(.fadeTransitionWithLogo)

    // MARK: - Routing
    func routeToError() {
        guard let errorVC = ErrorBuilder().createErrorScene() else {
            return
        }
        navigateToError(destination: errorVC)
    }

    func routeToMoreEpisodes() {
        
        guard let moreEpisodesVC = MoreEpisodesBuilder().createMoreEpisodesScene(),
              var moreEpisodesDataStore = moreEpisodesVC.router?.dataStore else {
            return
        }
        passDataToMoreEpisodes(destination: &moreEpisodesDataStore)
        navigateToMoreEpisodes(destination: moreEpisodesVC)
    }

    func routeToContentPlayer() {
        guard let contentPlayerVC = ContentPlayerBuilder().createContentPlayerScene() else {
            return
        }
        navigateToContentPlayer(destination: contentPlayerVC)
    }

    func routeToRateContent() {
        
    }

    func routeToWatchLater() {
    }
}

// MARK: - Private methods
private extension VideoOnDemandDetailsRouter {
    // MARK: - Navigation
    func navigateToMoreEpisodes(destination: MoreEpisodesViewController) {
        destination.modalPresentationStyle = .overCurrentContext
        viewController?.present(destination, animated: true)
    }

    func navigateToError(destination: ErrorViewController) {
        destination.modalPresentationStyle = .overCurrentContext
        viewController?.present(destination, animated: true)
    }

    func navigateToContentPlayer(destination: ContentPlayerViewController) {
        destination.transitioningDelegate = transitionHelper
        destination.modalPresentationStyle = .custom
        viewController?.present(destination, animated: true)
    }

    // MARK: - Passing data
    func passDataToMoreEpisodes(destination: inout MoreEpisodesDataStore) {
        destination.videoOnDemandItem = dataStore?.videoOnDemandItem
    }
}
