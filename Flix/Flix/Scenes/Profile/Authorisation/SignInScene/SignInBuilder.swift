//
//  
//  SignInBuilder.swift
//  FlixAR
//
//  Created by Anton Romanov on 13.10.2021.
//
//

protocol SignInBuildingLogic {
    func createSignInScene() -> SignInViewController?
}

final class SignInBuilder: SignInBuildingLogic {
    func createSignInScene() -> SignInViewController? {

        guard let vc = AppScene.signIn.viewController(SignInViewController.self) else {
            return nil
        }
        let interactor = SignInInteractor()
        let presenter = SignInPresenter()
        let router = SignInRouter()

        interactor.presenter = presenter
        presenter.viewController = vc
        router.viewController = vc
        router.dataStore = interactor

        vc.interactor = interactor
        vc.router = router
        return vc
    }
}
