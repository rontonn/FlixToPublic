//
//  
//  ErrorBuilder.swift
//  Flix
//
//  Created by Anton Romanov on 29.10.2021.
//
//

protocol ErrorBuildingLogic {
    func createErrorScene() -> ErrorViewController?
}

final class ErrorBuilder: ErrorBuildingLogic {
    func createErrorScene() -> ErrorViewController? {

        guard let vc = AppScene.error.viewController(ErrorViewController.self) else {
            return nil
        }
        let interactor = ErrorInteractor()
        let presenter = ErrorPresenter()
        let router = ErrorRouter()

        interactor.presenter = presenter
        presenter.viewController = vc
        router.viewController = vc
        router.dataStore = interactor

        vc.interactor = interactor
        vc.router = router
        return vc
    }
}
