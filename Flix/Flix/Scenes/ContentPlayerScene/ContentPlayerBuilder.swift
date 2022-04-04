//
//  
//  ContentPlayerBuilder.swift
//  Flix
//
//  Created by Anton Romanov on 12.11.2021.
//
//

protocol ContentPlayerBuildingLogic {
    func createContentPlayerScene() -> ContentPlayerViewController?
}

final class ContentPlayerBuilder: ContentPlayerBuildingLogic {
    func createContentPlayerScene() -> ContentPlayerViewController? {

        guard let vc = AppScene.contentPlayer.viewController(ContentPlayerViewController.self) else {
            return nil
        }
        let interactor = ContentPlayerInteractor()
        let presenter = ContentPlayerPresenter()
        let router = ContentPlayerRouter()

        interactor.presenter = presenter
        presenter.viewController = vc
        router.viewController = vc
        router.dataStore = interactor

        vc.interactor = interactor
        vc.router = router
        return vc
    }
}
