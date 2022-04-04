//
//  
//  PurchaseConsumptionTimeRouter.swift
//  Flix
//
//  Created by Anton Romanov on 09.11.2021.
//
//

import UIKit

typealias PurchaseConsumptionTimeRouterable = PurchaseConsumptionTimeRoutingLogic & PurchaseConsumptionTimeDataPassing

protocol PurchaseConsumptionTimeRoutingLogic {
    func routeToConfirmConsumptionTimePurchaseScene()
}

protocol PurchaseConsumptionTimeDataPassing {
    var dataStore: PurchaseConsumptionTimeDataStore? { get }
}

final class PurchaseConsumptionTimeRouter: PurchaseConsumptionTimeRouterable {
    // MARK: - Properties
    weak var viewController: PurchaseConsumptionTimeViewController?
    var dataStore: PurchaseConsumptionTimeDataStore?

    // MARK: - Routing
    func routeToConfirmConsumptionTimePurchaseScene() {
        guard let confirmConsumptionTimeVC = ConfirmConsumptionTimePurchaseBuilder().createConfirmConsumptionTimePurchaseScene(),
              var confirmConsumptionTimeDataSource = confirmConsumptionTimeVC.router?.dataStore else {
            return
        }
        passDataToConfirmConsumptionTimePurchaseScene(destination: &confirmConsumptionTimeDataSource)
        navigateToConfirmConsumptionTimePurchaseScene(confirmConsumptionTimeVC)
    }
}

// MARK: - Private methods
private extension PurchaseConsumptionTimeRouter {
    // MARK: - Navigation
    func navigateToConfirmConsumptionTimePurchaseScene(_ vc: ConfirmConsumptionTimePurchaseViewController) {
        viewController?.present(vc, animated: true)
    }

    // MARK: - Passing data
    func passDataToConfirmConsumptionTimePurchaseScene(destination: inout ConfirmConsumptionTimePurchaseDataStore) {
        destination.purchaseOption = dataStore?.selectedPurchaseOption
    }
}
