//
//  
//  HomeBuilder.swift
//  FlixAR
//
//  Created by Anton Romanov on 12.10.2021.
//
//

protocol HomeBuildingLogic {
    func createHomeScene() -> HomeViewController?
}

final class HomeBuilder: HomeBuildingLogic {
    func createHomeScene() -> HomeViewController? {

        guard let vc = AppScene.home.viewController(HomeViewController.self) else {
            return nil
        }
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        let router = HomeRouter()

        interactor.presenter = presenter
        presenter.viewController = vc
        router.viewController = vc
        router.dataStore = interactor

        vc.interactor = interactor
        vc.router = router
        return vc
    }
}
