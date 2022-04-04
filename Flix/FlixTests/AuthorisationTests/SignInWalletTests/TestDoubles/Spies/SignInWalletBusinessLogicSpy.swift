//
//  SignInWalletBusinessLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 17.11.2021.
//

import Foundation
@testable import Flix

final class SignInWalletBusinessLogicSpy {
    // MARK: - Properties
    private (set) var isCalledProvideInitialData = false
}

extension SignInWalletBusinessLogicSpy: SignInWalletBusinessLogic {
    func provideInitialData(_ request: SignInWalletModels.InitialData.Request) {
        isCalledProvideInitialData = true
    }
}
