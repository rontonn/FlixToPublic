//
//  
//  TvBuilder.swift
//  Flix
//
//  Created by Anton Romanov on 15.10.2021.
//
//

protocol TvBuildingLogic {
    func createTvScene(homeSidebarAppearanceDelegate: HomeSidebarAppearance?) -> TvViewController?
}

final class TvBuilder: TvBuildingLogic {
    func createTvScene(homeSidebarAppearanceDelegate: HomeSidebarAppearance?) -> TvViewController? {

        guard let vc = AppScene.tv.viewController(TvViewController.self) else {
            return nil
        }
        let interactor = TvInteractor()
        let presenter = TvPresenter()
        let router = TvRouter()

        interactor.presenter = presenter
        presenter.viewController = vc
        router.viewController = vc
        router.dataStore = interactor

        vc.interactor = interactor
        vc.router = router
        vc.homeSidebarAppearanceDelegate = homeSidebarAppearanceDelegate
        return vc
    }
}
