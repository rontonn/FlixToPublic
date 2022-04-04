//
//  EditProfileDisplayLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 16.11.2021.
//

import Foundation
@testable import Flix

final class EditProfileDisplayLogicSpy {
    // MARK: - Properties
    private (set) var isCalledDisplayEditProfileOptions = false
    private (set) var isCalledDisplayEditProfileOption = false
    private (set) var isCalledDisplayUpdatedEditProfileOptions = false
    private (set) var isCalledDisplayEditName = false
    private (set) var isCalledDisplayEditProfileImageScene = false
    private (set) var isCalledDisplayEditConsumptionTimeScene = false
}

extension EditProfileDisplayLogicSpy: EditProfileDisplayLogic {
    func displayEditProfileOptions(_ viewModel: EditProfileModels.InitialData.ViewModel) {
        isCalledDisplayEditProfileOptions = true
    }
    
    func displayEditProfileOption(_ viewModel: EditProfileModels.CollectionData.ViewModel) {
        isCalledDisplayEditProfileOption = true
    }
    
    func displayUpdatedEditProfileOptions(_ viewModel: EditProfileModels.UpdatedData.ViewModel) {
        isCalledDisplayUpdatedEditProfileOptions = true
    }

    func displayEditName(_ viewModel: EditProfileModels.FocusUpdated.ViewModel) {
        isCalledDisplayEditName = true
    }

    func displayEditProfileImageScene(_ viewModel: EditProfileModels.FocusUpdated.ViewModel) {
        isCalledDisplayEditProfileImageScene = true
    }

    func displayEditConsumptionTimeScene(_ viewModel: EditProfileModels.FocusUpdated.ViewModel) {
        isCalledDisplayEditConsumptionTimeScene = true
    }
}
