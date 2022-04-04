//
//  
//  EditConsumptionTimeInteractor.swift
//  Flix
//
//  Created by Anton Romanov on 09.11.2021.
//
//

protocol EditConsumptionTimeBusinessLogic {
    func fetchAvailableConsumptionTime(_ request: EditConsumptionTimeModels.InitialData.Request)
}

protocol EditConsumptionTimeDataStore {
    var availableConsumptionTime: String? { get set }
}

final class EditConsumptionTimeInteractor: EditConsumptionTimeDataStore {
    // MARK: - Properties
    var presenter: EditConsumptionTimePresentationLogic?
    var availableConsumptionTime: String?
}

extension EditConsumptionTimeInteractor: EditConsumptionTimeBusinessLogic {
    func fetchAvailableConsumptionTime(_ request: EditConsumptionTimeModels.InitialData.Request) {
        let response = EditConsumptionTimeModels.InitialData.Response(availableConsumptionTime: availableConsumptionTime)
        presenter?.presentAvailableConsumptionTime(response)
    }
}
