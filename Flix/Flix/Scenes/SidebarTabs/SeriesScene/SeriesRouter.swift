//
//  
//  SeriesRouter.swift
//  Flix
//
//  Created by Anton Romanov on 15.10.2021.
//
//

import UIKit

typealias SeriesRouterable = SeriesRoutingLogic & SeriesDataPassing

protocol SeriesRoutingLogic {
    func routeToContentDetails()
}

protocol SeriesDataPassing {
    var dataStore: SeriesDataStore? { get }
}

final class SeriesRouter: SeriesRouterable {
    // MARK: - Properties
    weak var viewController: SeriesViewController?
    var dataStore: SeriesDataStore?

    private lazy var transitionHelper = ControllerTransitionHelper(.fadeTransitionWithLogo)

    // MARK: - Routing
    func routeToContentDetails() {
        guard let videoOnDemandDetailsVC = VideoOnDemandDetailsBuilder().createVideoOnDemandDetailsScene() else {
            return
        }
        guard var videoOnDemandDetailssDataStore = videoOnDemandDetailsVC.router?.dataStore else {
            return
        }

        passDataToContentDetails(destination: &videoOnDemandDetailssDataStore)
        navigateToContentDetails(destination: videoOnDemandDetailsVC)
    }
}

// MARK: - Private methods
private extension SeriesRouter {
    // MARK: - Navigation
    func navigateToContentDetails(destination: VideoOnDemandDetailsViewController) {
        destination.transitioningDelegate = transitionHelper
        destination.modalPresentationStyle = .custom
        viewController?.present(destination, animated: true)
    }

    // MARK: - Passing data
    func passDataToContentDetails(destination: inout VideoOnDemandDetailsDataStore) {
    }
}
