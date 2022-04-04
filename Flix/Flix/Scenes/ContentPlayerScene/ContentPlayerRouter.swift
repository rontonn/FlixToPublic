//
//  
//  ContentPlayerRouter.swift
//  Flix
//
//  Created by Anton Romanov on 12.11.2021.
//
//

import UIKit

typealias ContentPlayerRouterable = ContentPlayerRoutingLogic & ContentPlayerDataPassing

protocol ContentPlayerRoutingLogic {
    func routeToErrorSceene()
}

protocol ContentPlayerDataPassing {
    var dataStore: ContentPlayerDataStore? { get }
}

final class ContentPlayerRouter: ContentPlayerRouterable {
    // MARK: - Properties
    weak var viewController: ContentPlayerViewController?
    var dataStore: ContentPlayerDataStore?

    // MARK: - Routing
    func routeToErrorSceene() {
        guard let errorVC = ErrorBuilder().createErrorScene(),
              var errorDataSource = errorVC.router?.dataStore else {
            return
        }
        passDataToErrorScene(destination: &errorDataSource)
        navigateToErrorScene(errorVC)
    }
}

// MARK: - Private methods
private extension ContentPlayerRouter {
    // MARK: - Navigation
    func navigateToErrorScene(_ vc: ErrorViewController) {
        vc.modalPresentationStyle = .blurOverFullScreen
        viewController?.present(vc, animated: true)
    }

    // MARK: - Passing data
    func passDataToErrorScene(destination: inout ErrorDataStore) {
        destination.error = dataStore?.playerError
    }
}
