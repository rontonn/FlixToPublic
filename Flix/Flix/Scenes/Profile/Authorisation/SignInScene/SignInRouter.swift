//
//  
//  SignInRouter.swift
//  FlixAR
//
//  Created by Anton Romanov on 13.10.2021.
//
//

import UIKit

typealias SignInRouterable = SignInRoutingLogic & SignInDataPassing

protocol SignInRoutingLogic {
    func routeToSigInWallet()
}

protocol SignInDataPassing {
    var dataStore: SignInDataStore? { get }
}

final class SignInRouter: SignInRouterable {
    // MARK: - Properties
    weak var viewController: SignInViewController?
    var dataStore: SignInDataStore?

    // MARK: - Routing
    func routeToSigInWallet() {
        guard let signInWalletVC = SignInWalletBuilder().createSignInWalletScene(),
              var signInWalletDataStore = signInWalletVC.router?.dataStore else {
          return
        }

        passDataToSignInWalletScene(&signInWalletDataStore)
        navigateToSignInWalletScene(signInWalletVC)
    }
}

// MARK: - Private methods
private extension SignInRouter {
    // MARK: - Navigation
    func navigateToSignInWalletScene(_ vc: SignInWalletViewController) {
        vc.modalPresentationStyle = .overCurrentContext
        viewController?.present(vc, animated: true)
    }

    // MARK: - Passing data
    func passDataToSignInWalletScene(_ signInWalletDataStore: inout SignInWalletDataStore) {
    }
}
