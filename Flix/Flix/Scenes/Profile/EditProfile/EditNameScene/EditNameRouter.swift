//
//  
//  EditNameRouter.swift
//  Flix
//
//  Created by Anton Romanov on 05.11.2021.
//
//

import UIKit

typealias EditNameRouterable = EditNameRoutingLogic & EditNameDataPassing

protocol EditNameRoutingLogic {
    func routeToErrorSceene()
}

protocol EditNameDataPassing {
    var dataStore: EditNameDataStore? { get }
}

final class EditNameRouter: EditNameRouterable {
    // MARK: - Properties
    weak var viewController: EditNameViewController?
    var dataStore: EditNameDataStore?

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
private extension EditNameRouter {
    // MARK: - Navigation
    func navigateToErrorScene(_ vc: ErrorViewController) {
        vc.modalPresentationStyle = .overCurrentContext
        viewController?.present(vc, animated: true)
    }

    // MARK: - Passing data
    func passDataToErrorScene(destination: inout ErrorDataStore) {
        destination.error = dataStore?.error
    }
}
