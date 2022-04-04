//
//  
//  SignInWalletPresenter.swift
//  Flix
//
//  Created by Anton Romanov on 14.10.2021.
//
//

protocol SignInWalletPresentationLogic {
    func presentInitialData(_ response: SignInWalletModels.InitialData.Response)
}

final class SignInWalletPresenter {
    // MARK: - Properties
    weak var viewController: SignInWalletDisplayLogic?
}

extension SignInWalletPresenter: SignInWalletPresentationLogic {
    func presentInitialData(_ response: SignInWalletModels.InitialData.Response) {
        let viewModel = SignInWalletModels.InitialData.ViewModel(pageTitle: response.pageTitle,
                                                                 qrImage: response.qrImage)
        viewController?.displayInitialData(viewModel)
    }
}
