//
//  EditNameBusinessLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 16.11.2021.
//

import Foundation
@testable import Flix

final class EditNameBusinessLogicSpy {
    // MARK: - Properties
    private (set) var isCalledFetchCurrentName = false
    private (set) var isCalledDidPressSaveNameButton = false
}

extension EditNameBusinessLogicSpy: EditNameBusinessLogic {
    func fetchCurrentName(_ request: EditNameModels.InitialData.Request) {
        isCalledFetchCurrentName = true
    }
    
    func didPressSaveNameButton(_ request: EditNameModels.Result.Request) {
        isCalledDidPressSaveNameButton = true
    }
}
