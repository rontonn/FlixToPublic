//
//  ProfilesBusinessLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 16.11.2021.
//

import Foundation
@testable import Flix

final class ProfilesBusinessLogicSpy {
    // MARK: - Properties
    private (set) var isCalledFetchProfiles = false
    private (set) var isCalledFetchProfile = false
    private (set) var isCalledDidSelectProfile = false
}

extension ProfilesBusinessLogicSpy: ProfilesBusinessLogic {
    func fetchProfiles(_ request: ProfilesModels.InitialData.Request) {
        isCalledFetchProfiles = true
    }

    func fetchProfile(_ request: ProfilesModels.ProfileData.Request) {
        isCalledFetchProfile = true
    }
    
    func didSelectProfile(_ request: ProfilesModels.EditProfile.Request) {
        isCalledDidSelectProfile = true
    }
}
