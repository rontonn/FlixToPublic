//
//  
//  EditNameBuilder.swift
//  Flix
//
//  Created by Anton Romanov on 05.11.2021.
//
//

protocol EditNameBuildingLogic {
    func createEditNameScene() -> EditNameViewController?
}

final class EditNameBuilder: EditNameBuildingLogic {
    func createEditNameScene() -> EditNameViewController? {

        guard let vc = AppScene.editName.viewController(EditNameViewController.self) else {
            return nil
        }
        let interactor = EditNameInteractor()
        let presenter = EditNamePresenter()
        let router = EditNameRouter()

        interactor.presenter = presenter
        presenter.viewController = vc
        router.viewController = vc
        router.dataStore = interactor

        vc.interactor = interactor
        vc.router = router
        return vc
    }
}
