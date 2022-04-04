//
//  
//  MoviesRouter.swift
//  Flix
//
//  Created by Anton Romanov on 15.10.2021.
//
//

import UIKit

typealias MoviesRouterable = MoviesRoutingLogic & MoviesDataPassing

protocol MoviesRoutingLogic {
    func routeToContentDetails()
}

protocol MoviesDataPassing {
    var dataStore: MoviesDataStore? { get }
}

final class MoviesRouter: MoviesRouterable {
    // MARK: - Properties
    weak var viewController: MoviesViewController?
    var dataStore: MoviesDataStore?

    private lazy var transitionHelper = ControllerTransitionHelper(.fadeTransitionWithLogo)

    // MARK: - Routing
    func routeToContentDetails() {
        guard let videoOnDemandDetailssVC = VideoOnDemandDetailsBuilder().createVideoOnDemandDetailsScene() else {
            return
        }
        guard var videoOnDemandDetailssDataStore = videoOnDemandDetailssVC.router?.dataStore else {
            return
        }

        passDataToContentDetails(destination: &videoOnDemandDetailssDataStore)
        navigateToContentDetails(destination: videoOnDemandDetailssVC)
    }
}

// MARK: - Private methods
private extension MoviesRouter {
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
