//
//  EditProfilePresentationLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 16.11.2021.
//

import Foundation
@testable import Flix

final class EditProfilePresentationLogicSpy {
    // MARK: - Properties
    private (set) var isCalledPresentEditProfileOptions = false
    private (set) var isCalledPresentEditProfileOption = false
    private (set) var isCalledPresentUpdatedEditProfilesOptions = false
    private (set) var isCalledPresentEditProfileDataAfterFocusUpdate = false
}

extension EditProfilePresentationLogicSpy: EditProfilePresentationLogic {
    func presentEditProfileOptions(_ response: EditProfileModels.InitialData.Response) {
        isCalledPresentEditProfileOptions = true
    }
    
    func presentEditProfileOption(_ response: EditProfileModels.CollectionData.Response) {
        isCalledPresentEditProfileOption = true
    }
    
    func presentUpdatedEditProfilesOptions(_ response: EditProfileModels.UpdatedData.Response) {
        isCalledPresentUpdatedEditProfilesOptions = true
    }

    func presentEditProfileDataAfterFocusUpdate(_ response: EditProfileModels.FocusUpdated.Response) {
        isCalledPresentEditProfileDataAfterFocusUpdate = true
    }
}
