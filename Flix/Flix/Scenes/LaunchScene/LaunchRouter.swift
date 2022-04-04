//
//  
//  LaunchRouter.swift
//  FlixAR
//
//  Created by Anton Romanov on 12.10.2021.
//
//

import UIKit

typealias LaunchRouterable = LaunchRoutingLogic & LaunchDataPassing

protocol LaunchRoutingLogic {
     func routeToHome()
}

protocol LaunchDataPassing {
  var dataStore: LaunchDataStore? { get }
}

final class LaunchRouter: LaunchRouterable {
    // MARK: - Properties
    weak var viewController: LaunchViewController?
    var dataStore: LaunchDataStore?

    // MARK: Routing
    func routeToHome() {
        guard let homeVC = HomeBuilder().createHomeScene(),
              var homeDataStore = homeVC.router?.dataStore else {
        return
     }
        passDataToHomeScene(&homeDataStore)
        navigateToHomeScene(homeVC)
    }
    
}

// MARK: - Private methods
private extension LaunchRouter {
    // MARK: - Navigation
    var window: UIWindow? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appDelegate.window else {
            print("\(String(describing: LaunchRouter.self)): Failed to get app delegate or its window.")
            return nil
        }
        return window
    }

    func navigateToHomeScene(_ vc: HomeViewController) {
        guard let window = window,
            let snapshot = window.snapshotView(afterScreenUpdates: true) else {
            return
        }
        vc.view.addSubview(snapshot)
        window.rootViewController = vc

        UIView.transition(with: window,
                          duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: { [weak snapshot] in
            snapshot?.alpha = 0
        },
                          completion: { [weak snapshot] _ in
            snapshot?.removeFromSuperview()
        })
    }

    // MARK: - Passing data
    func passDataToHomeScene(_ homeDataStore: inout HomeDataStore) {
    }
}
