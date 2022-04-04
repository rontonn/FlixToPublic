//
//  
//  ProfilesBuilder.swift
//  Flix
//
//  Created by Anton Romanov on 02.11.2021.
//
//

protocol ProfilesBuildingLogic {
    func createProfilesScene() -> ProfilesViewController?
}

final class ProfilesBuilder: ProfilesBuildingLogic {
    func createProfilesScene() -> ProfilesViewController? {

        guard let vc = AppScene.profiles.viewController(ProfilesViewController.self) else {
            return nil
        }
        let interactor = ProfilesInteractor()
        let presenter = ProfilesPresenter()
        let router = ProfilesRouter()

        interactor.presenter = presenter
        presenter.viewController = vc
        router.viewController = vc
        router.dataStore = interactor

        vc.interactor = interactor
        vc.router = router
        return vc
    }
}
