//
//  EditConsumptionTimeBusinessLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 17.11.2021.
//

import Foundation
@testable import Flix

final class EditConsumptionTimeBusinessLogicSpy {
    // MARK: - Properties
    private (set) var isCalledFetchAvailableConsumptionTime = false
}

extension EditConsumptionTimeBusinessLogicSpy: EditConsumptionTimeBusinessLogic {
    func fetchAvailableConsumptionTime(_ request: EditConsumptionTimeModels.InitialData.Request) {
        isCalledFetchAvailableConsumptionTime = true
    }
}
