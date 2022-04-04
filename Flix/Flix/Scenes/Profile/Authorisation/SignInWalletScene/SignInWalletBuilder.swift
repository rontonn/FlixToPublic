//
//  
//  SignInWalletBuilder.swift
//  Flix
//
//  Created by Anton Romanov on 14.10.2021.
//
//

protocol SignInWalletBuildingLogic {
    func createSignInWalletScene() -> SignInWalletViewController?
}

final class SignInWalletBuilder: SignInWalletBuildingLogic {
    func createSignInWalletScene() -> SignInWalletViewController? {

        guard let vc = AppScene.signInWallet.viewController(SignInWalletViewController.self) else {
            return nil
        }
        let interactor = SignInWalletInteractor()
        let presenter = SignInWalletPresenter()
        let router = SignInWalletRouter()

        interactor.presenter = presenter
        presenter.viewController = vc
        router.viewController = vc
        router.dataStore = interactor

        vc.interactor = interactor
        vc.router = router
        return vc
    }
}
