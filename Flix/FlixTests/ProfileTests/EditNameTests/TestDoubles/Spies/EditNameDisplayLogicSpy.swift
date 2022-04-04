//
//  EditNameDisplayLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 16.11.2021.
//

import Foundation
@testable import Flix

final class EditNameDisplayLogicSpy {
    // MARK: - Properties
    private (set) var isCalledDisplayCurrentName = false
    private (set) var isCalledDisplayEditNameError = false
    private (set) var isCalledDisplayEditNameSuccess = false
}

extension EditNameDisplayLogicSpy: EditNameDisplayLogic {
    func displayCurrentName(_ viewModel: EditNameModels.InitialData.ViewModel) {
        isCalledDisplayCurrentName = true
    }

    func displayEditNameSuccess(_ viewModel: EditNameModels.Result.ViewModel) {
        isCalledDisplayEditNameSuccess = true
    }

    func displayEditNameError(_ viewModel: EditNameModels.Result.ViewModel) {
        isCalledDisplayEditNameError = true
    }
}
