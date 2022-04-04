//
//  EditProfileBusinessLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 16.11.2021.
//

import Foundation
@testable import Flix

final class EditProfileBusinessLogicSpy {
    // MARK: - Properties
    private (set) var isCalledFetchEditProfileOptions = false
    private (set) var isCalledFetchEditProfileOption = false
    private (set) var isCalledDidUpdateFocus = false
}

extension EditProfileBusinessLogicSpy: EditProfileBusinessLogic {
    func fetchEditProfileOptions(_ request: EditProfileModels.InitialData.Request) {
        isCalledFetchEditProfileOptions = true
    }
    
    func fetchEditProfileOption(_ request: EditProfileModels.CollectionData.Request) {
        isCalledFetchEditProfileOption = true
    }

    func didUpdateFocus(_ request: EditProfileModels.FocusUpdated.Request) {
        isCalledDidUpdateFocus = true
    }
}
