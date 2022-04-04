//
//  
//  ConfirmConsumptionTimePurchaseBuilder.swift
//  Flix
//
//  Created by Anton Romanov on 10.11.2021.
//
//

protocol ConfirmConsumptionTimePurchaseBuildingLogic {
    func createConfirmConsumptionTimePurchaseScene() -> ConfirmConsumptionTimePurchaseViewController?
}

final class ConfirmConsumptionTimePurchaseBuilder: ConfirmConsumptionTimePurchaseBuildingLogic {
    func createConfirmConsumptionTimePurchaseScene() -> ConfirmConsumptionTimePurchaseViewController? {

        guard let vc = AppScene.confirmConsumptionTimePurchase.viewController(ConfirmConsumptionTimePurchaseViewController.self) else {
            return nil
        }
        let interactor = ConfirmConsumptionTimePurchaseInteractor()
        let presenter = ConfirmConsumptionTimePurchasePresenter()
        let router = ConfirmConsumptionTimePurchaseRouter()

        interactor.presenter = presenter
        presenter.viewController = vc
        router.viewController = vc
        router.dataStore = interactor

        vc.interactor = interactor
        vc.router = router
        return vc
    }
}
