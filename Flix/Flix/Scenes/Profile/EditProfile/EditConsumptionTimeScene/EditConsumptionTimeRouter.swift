//
//  
//  EditConsumptionTimeRouter.swift
//  Flix
//
//  Created by Anton Romanov on 09.11.2021.
//
//

import UIKit

typealias EditConsumptionTimeRouterable = EditConsumptionTimeRoutingLogic & EditConsumptionTimeDataPassing

protocol EditConsumptionTimeRoutingLogic {
    func routeToPurchaseConsumptionTimeSceene()
}

protocol EditConsumptionTimeDataPassing {
    var dataStore: EditConsumptionTimeDataStore? { get }
}

final class EditConsumptionTimeRouter: EditConsumptionTimeRouterable {
    // MARK: - Properties
    weak var viewController: EditConsumptionTimeViewController?
    var dataStore: EditConsumptionTimeDataStore?

    // MARK: - Routing
    func routeToPurchaseConsumptionTimeSceene() {
        guard let purchaseConsumptionTimeVC = PurchaseConsumptionTimeBuilder().createPurchaseConsumptionTimeScene(),
              var purchaseConsumptionTimeDataSource = purchaseConsumptionTimeVC.router?.dataStore else {
            return
        }
        passDataToPurchaseConsumptionTimeScene(destination: &purchaseConsumptionTimeDataSource)
        navigatePurchaseConsumptionTimeScene(purchaseConsumptionTimeVC)
    }
}

// MARK: - Private methods
private extension EditConsumptionTimeRouter {
    // MARK: - Navigation
    func navigatePurchaseConsumptionTimeScene(_ vc: PurchaseConsumptionTimeViewController) {
        viewController?.present(vc, animated: true)
    }

    // MARK: - Passing data
    func passDataToPurchaseConsumptionTimeScene(destination: inout PurchaseConsumptionTimeDataStore) {
        destination.availableConsumptionTime = dataStore?.availableConsumptionTime
    }
}
