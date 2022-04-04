//
//  
//  ConfirmConsumptionTimePurchaseRouter.swift
//  Flix
//
//  Created by Anton Romanov on 10.11.2021.
//
//

import UIKit

typealias ConfirmConsumptionTimePurchaseRouterable = ConfirmConsumptionTimePurchaseRoutingLogic & ConfirmConsumptionTimePurchaseDataPassing

protocol ConfirmConsumptionTimePurchaseRoutingLogic {
    func showPurchaseSuccessAlert()
}

protocol ConfirmConsumptionTimePurchaseDataPassing {
    var dataStore: ConfirmConsumptionTimePurchaseDataStore? { get }
}

final class ConfirmConsumptionTimePurchaseRouter: ConfirmConsumptionTimePurchaseRouterable {
    // MARK: - Properties
    weak var viewController: ConfirmConsumptionTimePurchaseViewController?
    var dataStore: ConfirmConsumptionTimePurchaseDataStore?

    // MARK: - Routing
    func showPurchaseSuccessAlert() {
        guard let alertVC = AlertBuilder().createAlertScene(),
              var alertDataStore = alertVC.router?.dataStore else {
            return
        }
        passDataToPurchaseSuccessAlert(&alertDataStore)
        navigateToPurchaseSuccessAlert(alertVC)
    }
}

// MARK: - Private methods
private extension ConfirmConsumptionTimePurchaseRouter {
    // MARK: - Navigation
    func navigateToPurchaseSuccessAlert(_ vc: UIViewController) {
        vc.modalPresentationStyle = .overFullScreen
        viewController?.present(vc, animated: true)
    }

    // MARK: - Passing data
    func passDataToPurchaseSuccessAlert(_ alertDataStore: inout AlertDataStore) {
        alertDataStore.info = dataStore?.purchaseSuccessAlert
    }
}
