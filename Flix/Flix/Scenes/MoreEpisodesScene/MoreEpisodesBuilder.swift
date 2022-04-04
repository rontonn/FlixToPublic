//
//  
//  MoreEpisodesBuilder.swift
//  Flix
//
//  Created by Anton Romanov on 25.10.2021.
//
//

protocol MoreEpisodesBuildingLogic {
    func createMoreEpisodesScene() -> MoreEpisodesViewController?
}

final class MoreEpisodesBuilder: MoreEpisodesBuildingLogic {
    func createMoreEpisodesScene() -> MoreEpisodesViewController? {

        guard let vc = AppScene.moreEpisodes.viewController(MoreEpisodesViewController.self) else {
            return nil
        }
        let interactor = MoreEpisodesInteractor()
        let presenter = MoreEpisodesPresenter()
        let router = MoreEpisodesRouter()

        interactor.presenter = presenter
        presenter.viewController = vc
        router.viewController = vc
        router.dataStore = interactor

        vc.interactor = interactor
        vc.router = router
        return vc
    }
}
