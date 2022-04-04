//
//  AlertDisplayLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 19.11.2021.
//

import Foundation
@testable import Flix

final class AlertDisplayLogicSpy {
    // MARK: - Properties
    private (set) var isCalledDisplayAlert = false
    private (set) var isCalledDisplayAlertActionData = false
    private (set) var isCalledCloseAlert = false
}

extension AlertDisplayLogicSpy: AlertDisplayLogic {
    func displayAlert(_ viewModel: AlertModels.InitialData.ViewModel) {
        isCalledDisplayAlert = true
    }

    func displayAlertActionData(_ viewModel: AlertModels.AlertActionData.ViewModel) {
        isCalledDisplayAlertActionData = true
    }

    func closeAlert(_ viewModel: AlertModels.SelectAlertAction.ViewModel) {
        isCalledCloseAlert = true
    }
}
