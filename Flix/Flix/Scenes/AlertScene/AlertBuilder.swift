//
//  
//  AlertBuilder.swift
//  Flix
//
//  Created by Anton Romanov on 11.11.2021.
//
//

protocol AlertBuildingLogic {
    func createAlertScene() -> AlertViewController?
}

final class AlertBuilder: AlertBuildingLogic {
    func createAlertScene() -> AlertViewController? {

        guard let vc = AppScene.alert.viewController(AlertViewController.self) else {
            return nil
        }
        let interactor = AlertInteractor()
        let presenter = AlertPresenter()
        let router = AlertRouter()

        interactor.presenter = presenter
        presenter.viewController = vc
        router.viewController = vc
        router.dataStore = interactor

        vc.router = router
        vc.interactor = interactor
        return vc
    }
}
