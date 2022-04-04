//
//  
//  EditConsumptionTimeBuilder.swift
//  Flix
//
//  Created by Anton Romanov on 09.11.2021.
//
//

protocol EditConsumptionTimeBuildingLogic {
    func createEditConsumptionTimeScene() -> EditConsumptionTimeViewController?
}

final class EditConsumptionTimeBuilder: EditConsumptionTimeBuildingLogic {
    func createEditConsumptionTimeScene() -> EditConsumptionTimeViewController? {

        guard let vc = AppScene.editConsumptionTime.viewController(EditConsumptionTimeViewController.self) else {
            return nil
        }
        let interactor = EditConsumptionTimeInteractor()
        let presenter = EditConsumptionTimePresenter()
        let router = EditConsumptionTimeRouter()

        interactor.presenter = presenter
        presenter.viewController = vc
        router.viewController = vc
        router.dataStore = interactor

        vc.interactor = interactor
        vc.router = router
        return vc
    }
}
