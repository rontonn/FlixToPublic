//
//  
//  EditProfileBuilder.swift
//  Flix
//
//  Created by Anton Romanov on 03.11.2021.
//
//

protocol EditProfileBuildingLogic {
    func createEditProfileScene() -> EditProfileViewController?
}

final class EditProfileBuilder: EditProfileBuildingLogic {
    func createEditProfileScene() -> EditProfileViewController? {
        guard let vc = AppScene.editProfile.viewController(EditProfileViewController.self) else {
            return nil
        }
        let interactor = EditProfileInteractor()
        let presenter = EditProfilePresenter()
        let router = EditProfileRouter()

        interactor.presenter = presenter
        interactor.editNameResultableDelegate = interactor
        interactor.editProfileImageResultable = interactor
        presenter.viewController = vc
        router.viewController = vc
        router.dataStore = interactor

        vc.interactor = interactor
        vc.router = router
        return vc
    }
}
