//
//  SignInWalletDisplayLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 17.11.2021.
//

import Foundation
@testable import Flix

final class SignInWalletDisplayLogicSpy {
    // MARK: - Properties
    private (set) var isCalledDisplayInitialData = false
}

extension SignInWalletDisplayLogicSpy: SignInWalletDisplayLogic {
    func displayInitialData(_ viewModel: SignInWalletModels.InitialData.ViewModel) {
        isCalledDisplayInitialData = true
    }
}
