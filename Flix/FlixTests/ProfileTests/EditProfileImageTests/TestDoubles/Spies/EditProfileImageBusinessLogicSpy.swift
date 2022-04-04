//
//  EditProfileImageBusinessLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 16.11.2021.
//

import Foundation
@testable import Flix

final class EditProfileImageBusinessLogicSpy {
    // MARK: - Properties
    private (set) var isCalledFetchEditProfileImageOptions = false
    private (set) var isCalledFetchEditProfileImageOption = false
}

extension EditProfileImageBusinessLogicSpy: EditProfileImageBusinessLogic {
    func fetchEditProfileImageOptions(_ request: EditProfileImageModels.InitialData.Request) {
        isCalledFetchEditProfileImageOptions = true
    }
    
    func fetchEditProfileImageOption(_ request: EditProfileImageModels.CollectionData.Request) {
        isCalledFetchEditProfileImageOption = true
    }
}
