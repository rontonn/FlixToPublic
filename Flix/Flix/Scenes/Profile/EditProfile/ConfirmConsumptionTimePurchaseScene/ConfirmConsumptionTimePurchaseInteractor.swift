//
//  
//  ConfirmConsumptionTimePurchaseInteractor.swift
//  Flix
//
//  Created by Anton Romanov on 10.11.2021.
//
//

import Foundation

protocol ConfirmConsumptionTimePurchaseBusinessLogic {
    func fetchPurchaseOption(_ request: ConfirmConsumptionTimePurchaseModels.InitialData.Request)
    func didPressApproveConsumptionTimePurchase(_ request: ConfirmConsumptionTimePurchaseModels.MakePurchase.Request)
}

protocol ConfirmConsumptionTimePurchaseDataStore {
    var purchaseOption: PurchaseConsumptionTimeOption? { get set }
    var purchaseSuccessAlert: AlertModels.Info { get }
}

final class ConfirmConsumptionTimePurchaseInteractor: ConfirmConsumptionTimePurchaseDataStore {
    // MARK: - Properties
    var presenter: ConfirmConsumptionTimePurchasePresentationLogic?

    var purchaseOption: PurchaseConsumptionTimeOption?
    var purchaseSuccessAlert = AlertModels.Info(image: #imageLiteral(resourceName: "movieIconBig"),
                                                title: "purchase_success_alert_title".localized,
                                                subtitle: "purchase_success_alert_subtitle".localized)
}

// MARK: - ConfirmConsumptionTimePurchaseBusinessLogic
extension ConfirmConsumptionTimePurchaseInteractor: ConfirmConsumptionTimePurchaseBusinessLogic {
    func fetchPurchaseOption(_ request: ConfirmConsumptionTimePurchaseModels.InitialData.Request) {
        guard let purchaseOption = purchaseOption else {
            return
        }
        let response = ConfirmConsumptionTimePurchaseModels.InitialData.Response(purchaseOption: purchaseOption)
        presenter?.presentPurchaseOption(response)
    }

    func didPressApproveConsumptionTimePurchase(_ request: ConfirmConsumptionTimePurchaseModels.MakePurchase.Request) {
        Task(priority: .utility) {
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            await didCompletePurchase()
        }
    }
}

// MARK: - Private methods
private extension ConfirmConsumptionTimePurchaseInteractor {
    @MainActor
    func didCompletePurchase() {
        let response = ConfirmConsumptionTimePurchaseModels.MakePurchase.Response()
        presenter?.didCompletePurchase(response)
    }
}
