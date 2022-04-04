//
//  
//  MusicBuilder.swift
//  Flix
//
//  Created by Anton Romanov on 15.10.2021.
//
//

protocol MusicBuildingLogic {
    func createMusicScene(homeSidebarAppearanceDelegate: HomeSidebarAppearance?) -> MusicViewController?
}

final class MusicBuilder: MusicBuildingLogic {
    func createMusicScene(homeSidebarAppearanceDelegate: HomeSidebarAppearance?) -> MusicViewController? {

        guard let vc = AppScene.music.viewController(MusicViewController.self) else {
            return nil
        }
        let interactor = MusicInteractor()
        let presenter = MusicPresenter()
        let router = MusicRouter()

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
