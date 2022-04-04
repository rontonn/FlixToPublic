//
//  SignInWalletPresentationLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 17.11.2021.
//

import Foundation
@testable import Flix

final class SignInWalletPresentationLogicSpy {
    // MARK: - Properties
    private (set) var isCalledPresentInitialData = false
}

extension SignInWalletPresentationLogicSpy: SignInWalletPresentationLogic {
    func presentInitialData(_ response: SignInWalletModels.InitialData.Response) {
        isCalledPresentInitialData = true
    }
}
