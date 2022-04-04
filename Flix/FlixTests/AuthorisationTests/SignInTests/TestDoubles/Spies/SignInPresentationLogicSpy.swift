//
//  SignInPresentationLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 17.11.2021.
//

import Foundation
@testable import Flix

final class SignInPresentationLogicSpy {
    // MARK: - Properties
    private (set) var isCalledPresentSignInOptions = false
    private (set) var isCalledPresentSignInOption = false
    private (set) var isCalledPresentSelectedSignInOption = false
}

extension SignInPresentationLogicSpy: SignInPresentationLogic {
    func presentSignInOptions(_ response: SignInModels.InitialData.Response) {
        isCalledPresentSignInOptions = true
    }

    func presentSignInOption(_ response: SignInModels.SignInOptionData.Response) {
        isCalledPresentSignInOption = true
    }
    
    func presentSelectedSignInOption(_ response: SignInModels.SelectSignInOption.Response) {
        isCalledPresentSelectedSignInOption = true
    }
}
