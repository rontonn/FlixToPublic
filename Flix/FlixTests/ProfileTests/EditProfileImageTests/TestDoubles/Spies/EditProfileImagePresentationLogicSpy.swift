//
//  EditProfileImagePresentationLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 16.11.2021.
//

import Foundation
@testable import Flix

final class EditProfileImagePresentationLogicSpy {
    // MARK: - Properties
    private (set) var isCalledPresentEditProfileImageOptions = false
    private (set) var isCalledPresentEditProfileImageOption = false
}

extension EditProfileImagePresentationLogicSpy: EditProfileImagePresentationLogic {
    func presentEditProfileImageOptions(_ response: EditProfileImageModels.InitialData.Response) {
        isCalledPresentEditProfileImageOptions = true
    }
    
    func presentEditProfileImageOption(_ response: EditProfileImageModels.CollectionData.Response) {
        isCalledPresentEditProfileImageOption = true
    }
}
