//
//  FadeTransitionWithLogo.swift
//  Flix
//
//  Created by Anton Romanov on 29.11.2021.
//

import UIKit

class FadeTransitionWithLogo: NSObject {
    // MARK: - Properties
    private let imageView: UIImageView = {
        let i = UIImageView(frame: .zero)
        i.translatesAutoresizingMaskIntoConstraints = false
        i.contentMode = .scaleAspectFit
        i.backgroundColor = .clear
        i.alpha = 0.5
        i.image = #imageLiteral(resourceName: "3dLogo")
        return i
    }()

    private let duration = 0.3
    private var presenting = true
}

// MARK: - UIViewControllerAnimatedTransitioning
extension FadeTransitionWithLogo: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toView = transitionContext.view(forKey: .to)
        let fromView = transitionContext.view(forKey: .from)

        guard let viewUnderTransition = presenting ? toView : fromView  else {
            return
        }

        let containerView = transitionContext.containerView
        containerView.backgroundColor = .black

        addImageViewIfNeeded(containerView)

        if let toView = toView {
            containerView.addSubview(toView)
            containerView.bringSubviewToFront(viewUnderTransition)
        }
        viewUnderTransition.alpha = presenting ? 0.0 : 1.0

        UIView.animateKeyframes(withDuration: duration, delay: 0.0, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1.0, animations: {
                viewUnderTransition.alpha = self.presenting ? 1.0 : 0.0
            })
        }, completion: { [weak self] _ in
            self?.presenting.toggle()
            transitionContext.completeTransition(true)
        })
    }
}

// MARK: - Private methods
private extension FadeTransitionWithLogo {
    func addImageViewIfNeeded(_ containerView: UIView) {
        if presenting {
            containerView.addSubview(imageView)
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                imageView.heightAnchor.constraint(equalToConstant: 20)
            ])
        }
    }
}
