//
//  SignInDisplayLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 17.11.2021.
//

import Foundation
@testable import Flix

final class SignInDisplayLogicSpy {
    // MARK: - Properties
    private (set) var isCalledDisplaySignInOptions = false
    private (set) var isCalledDisplaySignInOption = false
    private (set) var isCalledDisplaySignInWithWallet = false
    private (set) var isCalledDisplaySignInWithQR = false
}

extension SignInDisplayLogicSpy: SignInDisplayLogic {
    func displaySignInOptions(_ viewModel: SignInModels.InitialData.ViewModel) {
        isCalledDisplaySignInOptions = true
    }

    func displaySignInOption(_ viewModel: SignInModels.SignInOptionData.ViewModel) {
        isCalledDisplaySignInOption = true
    }

    func displaySignInWithWallet(_ viewModel: SignInModels.SelectSignInOption.ViewModel) {
        isCalledDisplaySignInWithWallet = true
    }
    
    func displaySignInWithQR(_ viewModel: SignInModels.SelectSignInOption.ViewModel) {
        isCalledDisplaySignInWithQR = true
    }
}
