//
//  
//  EditConsumptionTimePresenter.swift
//  Flix
//
//  Created by Anton Romanov on 09.11.2021.
//
//

protocol EditConsumptionTimePresentationLogic {
    func presentAvailableConsumptionTime(_ response: EditConsumptionTimeModels.InitialData.Response)
}

final class EditConsumptionTimePresenter {
    // MARK: - Properties
    weak var viewController: EditConsumptionTimeDisplayLogic?
}

extension EditConsumptionTimePresenter: EditConsumptionTimePresentationLogic {
    func presentAvailableConsumptionTime(_ response: EditConsumptionTimeModels.InitialData.Response) {
        let viewModel = EditConsumptionTimeModels.InitialData.ViewModel(availableConsumptionTime: response.availableConsumptionTime)
        viewController?.displayAvailableConsumptionTime(viewModel)
    }
}
