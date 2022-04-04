//
//  EditNamePresentationLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 16.11.2021.
//

import Foundation
@testable import Flix

final class EditNamePresentationLogicSpy {
    // MARK: - Properties
    private (set) var isCalledPresentCurrentName = false
    private (set) var isCalledPresentEditNameSuccess = false
    private (set) var isCalledPresentEditNameError = false
}

extension EditNamePresentationLogicSpy: EditNamePresentationLogic {
    func presentCurrentName(_ response: EditNameModels.InitialData.Response) {
        isCalledPresentCurrentName = true
    }

    func presentEditNameSuccess(_ response: EditNameModels.Result.Response) {
        isCalledPresentEditNameSuccess = true
    }

    func presentEditNameError(_ response: EditNameModels.Result.Response) {
        isCalledPresentEditNameError = true
    }
}
