//
//  ErrorPresentationLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 19.11.2021.
//

import Foundation
@testable import Flix

final class ErrorPresentationLogicSpy {
    // MARK: - Properties
    private (set) var isCalledPresentError = false
    private (set) var isCalledPresentErrorActionData = false
    private (set) var isCalledPresentSelectedErrorAction = false
}

extension ErrorPresentationLogicSpy: ErrorPresentationLogic {
    func presentError(_ reponse: ErrorModels.InitialData.Response) {
        isCalledPresentError = true
    }
    
    func presentErrorActionData(_ reponse: ErrorModels.ErrorActionData.Response) {
        isCalledPresentErrorActionData = true
    }
    
    func presentSelectedErrorAction(_ response: ErrorModels.SelectErrorAction.Response) {
        isCalledPresentSelectedErrorAction = true
    }
}
