//
//  ErrorBusinessLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 19.11.2021.
//

import Foundation
@testable import Flix

final class ErrorBusinessLogicSpy {
    // MARK: - Properties
    private (set) var isCalledFetchErrorInfo = false
    private (set) var isCalledFetchErrorActionData = false
    private (set) var isCalledDidSelectErrorAction = false
}

extension ErrorBusinessLogicSpy: ErrorBusinessLogic {
    func fetchErrorInfo(_ request: ErrorModels.InitialData.Request) {
        isCalledFetchErrorInfo = true
    }
    
    func fetchErrorActionData(_ request: ErrorModels.ErrorActionData.Request) {
        isCalledFetchErrorActionData = true
    }

    func didSelectErrorAction(_ request: ErrorModels.SelectErrorAction.Request) {
        isCalledDidSelectErrorAction = true
    }
}
