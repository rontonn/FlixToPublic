//
//  
//  ConfirmConsumptionTimePurchasePresenter.swift
//  Flix
//
//  Created by Anton Romanov on 10.11.2021.
//
//

protocol ConfirmConsumptionTimePurchasePresentationLogic {
    func presentPurchaseOption(_ response: ConfirmConsumptionTimePurchaseModels.InitialData.Response)
    func didCompletePurchase(_ response: ConfirmConsumptionTimePurchaseModels.MakePurchase.Response)
    
}

final class ConfirmConsumptionTimePurchasePresenter {
    // MARK: - Properties
    weak var viewController: ConfirmConsumptionTimePurchaseDisplayLogic?
}

extension ConfirmConsumptionTimePurchasePresenter: ConfirmConsumptionTimePurchasePresentationLogic {
    func presentPurchaseOption(_ response: ConfirmConsumptionTimePurchaseModels.InitialData.Response) {
        let viewModel = ConfirmConsumptionTimePurchaseModels.InitialData.ViewModel(purchaseOption: response.purchaseOption)
        viewController?.displayPurchaseOption(viewModel)
    }

    func didCompletePurchase(_ response: ConfirmConsumptionTimePurchaseModels.MakePurchase.Response) {
        let viewModel = ConfirmConsumptionTimePurchaseModels.MakePurchase.ViewModel()
        viewController?.didCompletePurchase(viewModel)
    }
}
