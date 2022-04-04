//
//  
//  PurchaseConsumptionTimeBuilder.swift
//  Flix
//
//  Created by Anton Romanov on 09.11.2021.
//
//

protocol PurchaseConsumptionTimeBuildingLogic {
    func createPurchaseConsumptionTimeScene() -> PurchaseConsumptionTimeViewController?
}

final class PurchaseConsumptionTimeBuilder: PurchaseConsumptionTimeBuildingLogic {
    func createPurchaseConsumptionTimeScene() -> PurchaseConsumptionTimeViewController? {

        guard let vc = AppScene.purchaseConsumptionTime.viewController(PurchaseConsumptionTimeViewController.self) else {
            return nil
        }
        let interactor = PurchaseConsumptionTimeInteractor()
        let presenter = PurchaseConsumptionTimePresenter()
        let router = PurchaseConsumptionTimeRouter()

        interactor.presenter = presenter
        presenter.viewController = vc
        router.viewController = vc
        router.dataStore = interactor

        vc.interactor = interactor
        vc.router = router
        return vc
    }
}
