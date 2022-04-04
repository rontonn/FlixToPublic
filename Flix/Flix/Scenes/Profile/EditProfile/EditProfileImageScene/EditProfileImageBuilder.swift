//
//  
//  EditProfileImageBuilder.swift
//  Flix
//
//  Created by Anton Romanov on 08.11.2021.
//
//

protocol EditProfileImageBuildingLogic {
    func createEditProfileImageScene() -> EditProfileImageViewController?
}

final class EditProfileImageBuilder: EditProfileImageBuildingLogic {
    func createEditProfileImageScene() -> EditProfileImageViewController? {

        guard let vc = AppScene.editProfileImage.viewController(EditProfileImageViewController.self) else {
            return nil
        }
        let interactor = EditProfileImageInteractor()
        let presenter = EditProfileImagePresenter()
        let router = EditProfileImageRouter()

        interactor.presenter = presenter
        presenter.viewController = vc
        router.viewController = vc
        router.dataStore = interactor

        vc.interactor = interactor
        vc.router = router
        return vc
    }
}
