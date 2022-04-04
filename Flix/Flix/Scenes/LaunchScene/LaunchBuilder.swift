//
//  
//  LaunchBuilder.swift
//  FlixAR
//
//  Created by Anton Romanov on 12.10.2021.
//
//

protocol LaunchBuildingLogic {
    func createLaunchScene() -> LaunchViewController?
}

final class LaunchBuilder: LaunchBuildingLogic {
    func createLaunchScene() -> LaunchViewController? {

        guard let vc = AppScene.launch.viewController(LaunchViewController.self) else {
            return nil
        }
        let interactor = LaunchInteractor()
        let presenter = LaunchPresenter()
        let router = LaunchRouter()

        interactor.presenter = presenter
        presenter.viewController = vc
        router.viewController = vc
        router.dataStore = interactor

        vc.interactor = interactor
        vc.router = router
        return vc
    }
}
