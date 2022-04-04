//
//  EditConsumptionTimePresentationLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 17.11.2021.
//

import Foundation
@testable import Flix

final class EditConsumptionTimePresentationLogicSpy {
    // MARK: - Properties
    private (set) var isCalledPresentAvailableConsumptionTime = false
}

extension EditConsumptionTimePresentationLogicSpy: EditConsumptionTimePresentationLogic {
    func presentAvailableConsumptionTime(_ response: EditConsumptionTimeModels.InitialData.Response) {
        isCalledPresentAvailableConsumptionTime = true
    }
}
