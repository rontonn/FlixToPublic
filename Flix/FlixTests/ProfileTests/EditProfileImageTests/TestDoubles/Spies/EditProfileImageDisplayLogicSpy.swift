//
//  EditProfileImageDisplayLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 16.11.2021.
//

import Foundation
@testable import Flix

final class EditProfileImageDisplayLogicSpy {
    // MARK: - Properties
    private (set) var isCalledDisplayEditProfileImageOptions = false
    private (set) var isCalledDisplayEditProfileImageOption = false
}

extension EditProfileImageDisplayLogicSpy: EditProfileImageDisplayLogic {
    func displayEditProfileImageOptions(_ viewModel: EditProfileImageModels.InitialData.ViewModel) {
        isCalledDisplayEditProfileImageOptions = true
    }
    
    func displayEditProfileImageOption(_ viewModel: EditProfileImageModels.CollectionData.ViewModel) {
        isCalledDisplayEditProfileImageOption = true
    }
}
