//
//  ControllerTransitionHelper.swift
//  Flix
//
//  Created by Anton Romanov on 29.11.2021.
//

import UIKit

final class ControllerTransitionHelper: NSObject {
    // MARK: - Properties
    private var transition: UIViewControllerAnimatedTransitioning?

    // MARK: - Lifecycle
    init(_ transitionType: ControllerTransition) {
        switch transitionType {
        case .fadeTransitionWithLogo:
            transition = FadeTransitionWithLogo()
        }
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension ControllerTransitionHelper: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transition
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transition
    }
}

extension ControllerTransitionHelper {
    enum ControllerTransition {
        case fadeTransitionWithLogo
    }
}
