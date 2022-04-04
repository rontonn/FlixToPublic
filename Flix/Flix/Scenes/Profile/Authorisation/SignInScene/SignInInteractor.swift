//
//  
//  SignInInteractor.swift
//  FlixAR
//
//  Created by Anton Romanov on 13.10.2021.
//
//

protocol SignInBusinessLogic {
    func fetchSignInOptions(_ request: SignInModels.InitialData.Request)
    func fetchSignInOption(_ request: SignInModels.SignInOptionData.Request)
    func didSelectSignInOption(_ request: SignInModels.SelectSignInOption.Request)
}

protocol SignInDataStore {
    var signInOptions: [SignInOption] { get }
}

final class SignInInteractor: SignInDataStore {
    // MARK: - Properties
    var presenter: SignInPresentationLogic?
    var signInOptions: [SignInOption] = []
}

extension SignInInteractor: SignInBusinessLogic {
    func fetchSignInOptions(_ request: SignInModels.InitialData.Request) {
        signInOptions = [SignInOption(option: .wallet),
                         SignInOption(option: .qr)]
        let response = SignInModels.InitialData.Response(signInOptions: signInOptions)
        presenter?.presentSignInOptions(response)
    }

    func fetchSignInOption(_ request: SignInModels.SignInOptionData.Request) {
        guard let signInOption = signInOptions[safe: request.indexPath.item] else {
            return
        }
        let response = SignInModels.SignInOptionData.Response(object: request.object, signInOption: signInOption)
        presenter?.presentSignInOption(response)
    }

    func didSelectSignInOption(_ request: SignInModels.SelectSignInOption.Request) {
        guard let signInOption = signInOptions[safe: request.indexPath.item] else {
            return
        }
        let response = SignInModels.SelectSignInOption.Response(option: signInOption.option)
        presenter?.presentSelectedSignInOption(response)
    }
}
