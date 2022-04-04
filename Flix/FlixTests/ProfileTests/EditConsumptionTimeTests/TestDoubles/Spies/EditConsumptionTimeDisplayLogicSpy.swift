//
//  EditConsumptionTimeDisplayLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 17.11.2021.
//

import Foundation
@testable import Flix

final class EditConsumptionTimeDisplayLogicSpy {
    // MARK: - Properties
    private (set) var isCalledDisplayAvailableConsumptionTime = false
}

extension EditConsumptionTimeDisplayLogicSpy: EditConsumptionTimeDisplayLogic {
    func displayAvailableConsumptionTime(_ viewModel: EditConsumptionTimeModels.InitialData.ViewModel) {
        isCalledDisplayAvailableConsumptionTime = true
    }
}
