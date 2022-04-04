//
//  SignInBusinessLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 17.11.2021.
//

import Foundation
@testable import Flix

final class SignInBusinessLogicSpy {
    // MARK: - Properties
    private (set) var isCalledProvideSignInOptions = false
    private (set) var isCalledProvideSignInOption = false
    private (set) var isCalledDidSelectSignInOption = false
}

extension SignInBusinessLogicSpy: SignInBusinessLogic {
    func fetchSignInOptions(_ request: SignInModels.InitialData.Request) {
        isCalledProvideSignInOptions = true
    }

    func fetchSignInOption(_ request: SignInModels.SignInOptionData.Request) {
        isCalledProvideSignInOption = true
    }

    func didSelectSignInOption(_ request: SignInModels.SelectSignInOption.Request) {
        isCalledDidSelectSignInOption = true
    }
}
