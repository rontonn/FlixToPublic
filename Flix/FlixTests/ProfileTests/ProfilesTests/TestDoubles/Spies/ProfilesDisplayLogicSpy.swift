//
//  ProfilesDisplayLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 16.11.2021.
//

import Foundation
@testable import Flix

final class ProfilesDisplayLogicSpy {
    // MARK: - Properties
    private (set) var isCalledDisplayProfiles = false
    private (set) var isCalledDisplayProfile = false
    private (set) var isCalledDisplayEditProfile = false
    private (set) var isCalledDisplayLoading = false
}

extension ProfilesDisplayLogicSpy: ProfilesDisplayLogic {
    func displayProfiles(_ viewModel: ProfilesModels.InitialData.ViewModel) {
        isCalledDisplayProfiles = true
    }

    func displayProfile(_ viewModel: ProfilesModels.ProfileData.ViewModel) {
        isCalledDisplayProfile = true
    }

    func displayEditProfile(_ viewModel: ProfilesModels.EditProfile.ViewModel) {
        isCalledDisplayEditProfile = true
    }

    func displayLoading(_ viewModel: ProfilesModels.EditProfile.ViewModel) {
        isCalledDisplayLoading = true
    }
}
