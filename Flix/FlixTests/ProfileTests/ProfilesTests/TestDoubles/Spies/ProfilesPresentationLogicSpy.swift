//
//  ProfilesPresentationLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 16.11.2021.
//

import Foundation
@testable import Flix

final class ProfilesPresentationLogicSpy {
    // MARK: - Properties
    private (set) var isCalledPresentProfiles = false
    private (set) var isCalledPresentProfile = false
    private (set) var isCalledPresentEditProfile = false
    private (set) var isCalledPresentLoading = false
}

extension ProfilesPresentationLogicSpy: ProfilesPresentationLogic {
    func presentProfiles(_ response: ProfilesModels.InitialData.Response) {
        isCalledPresentProfiles = true
    }

    func presentProfile(_ response: ProfilesModels.ProfileData.Response) {
        isCalledPresentProfile = true
    }
    
    func presentEditProfile(_ response: ProfilesModels.EditProfile.Response) {
        isCalledPresentEditProfile = true
    }

    func presentLoading(_ response: ProfilesModels.EditProfile.Response) {
        isCalledPresentLoading = true
    }
}
