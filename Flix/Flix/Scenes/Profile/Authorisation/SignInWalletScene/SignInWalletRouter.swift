//
//  
//  SignInWalletRouter.swift
//  Flix
//
//  Created by Anton Romanov on 14.10.2021.
//
//

import UIKit

typealias SignInWalletRouterable = SignInWalletRoutingLogic & SignInWalletDataPassing

protocol SignInWalletRoutingLogic {
    // func routeToSomeWhere()
}

protocol SignInWalletDataPassing {
    var dataStore: SignInWalletDataStore? { get }
}

final class SignInWalletRouter: SignInWalletRouterable {
    // MARK: - Properties
    weak var viewController: SignInWalletViewController?
    var dataStore: SignInWalletDataStore?

    // MARK: - Routing
    /*
     func routeToSomeWhere() {
         let someVC = SomeVC()
         
         guard var someDataStore = someVC.router?.dataStore else {
           return
         }

         passDataToSomewhere(destination: &someDataStore)
         navigateToSomewhere(destination: someViewController)
     }
     */
}

// MARK: - Private methods
private extension SignInWalletRouter {
    // MARK: - Navigation
    /*
    func navigateToSomewhere(destination: SomeViewController) {
        viewController presents destinatination
     }
     */

    // MARK: - Passing data
    /*
    func passDataToSomeWhere(destination: inout SomeDataStore) {
        destination.some = dataStore?.some
     }
     */
}
