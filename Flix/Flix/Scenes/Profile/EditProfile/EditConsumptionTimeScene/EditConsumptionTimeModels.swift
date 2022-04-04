//
//  
//  EditConsumptionTimeModels.swift
//  Flix
//
//  Created by Anton Romanov on 09.11.2021.
//
//

enum EditConsumptionTimeModels {
    // MARK: - InitialData
    enum InitialData {
        struct Request {}
        struct Response {
            let availableConsumptionTime: String?
        }
        struct ViewModel {
            let availableConsumptionTime: String?
        }
    }
}
