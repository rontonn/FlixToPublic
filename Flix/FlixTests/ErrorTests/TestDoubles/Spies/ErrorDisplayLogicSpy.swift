//
//  ErrorDisplayLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 19.11.2021.
//

import Foundation
@testable import Flix

final class ErrorDisplayLogicSpy {
    // MARK: - Properties
    private (set) var isCalledDisplayError = false
    private (set) var isCalledDisplayErrorActionData = false
    private (set) var isCalledCloseError = false
    private (set) var isCalledPerformSolutionOnError = false
}

extension ErrorDisplayLogicSpy: ErrorDisplayLogic {
    func displayError(_ viewModel: ErrorModels.InitialData.ViewModel) {
        isCalledDisplayError = true
    }

    func displayErrorActionData(_ viewModel: ErrorModels.ErrorActionData.ViewModel) {
        isCalledDisplayErrorActionData = true
    }

    func closeError(_ viewModel: ErrorModels.SelectErrorAction.ViewModel) {
        isCalledCloseError = true
    }
    
    func performSolutionOnError(_ viewModel: ErrorModels.SelectErrorAction.ViewModel) {
        isCalledPerformSolutionOnError = true
    }
}
