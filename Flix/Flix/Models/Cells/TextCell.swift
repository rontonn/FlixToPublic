//
//  TextCell.swift
//  FlixAR
//
//  Created by Anton Romanov on 13.10.2021.
//

import UIKit

final class TextCell: UICollectionViewCell {
    // MARK: - Properties
    private let titleLabel: UILabel = {
        let t = UILabel()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.adjustsFontForContentSizeCategory = true
        t.backgroundColor = .clear
        t.textColor = .white

        return t
    }()
    private let focusableBackgroundView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .grey23
        v.layer.cornerRadius = 34
        v.clipsToBounds = true
        return v
    }()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("TextCell 'init(coder:)' has not been implemented")
    }

    override func prepareForReuse() {
        titleLabel.text = nil
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        performUnfocusingAnimations(in: context, with: coordinator)
        performFocusingAnimations(in: context, with: coordinator)
    }

    // MARK: - Public methods
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}

// MARK: - Private methods
private extension TextCell {
    func configure() {
        contentView.addSubview(focusableBackgroundView)
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([focusableBackgroundView.topAnchor.constraint(equalTo: topAnchor),
                                     focusableBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
                                     focusableBackgroundView.leftAnchor.constraint(equalTo: leftAnchor),
                                     focusableBackgroundView.rightAnchor.constraint(equalTo: rightAnchor)])
        NSLayoutConstraint.activate([titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                                     titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)])
        setUnfocusedState()
    }

    // MARK: - Unfocusing animations
    func performFocusingAnimations(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedFocusingAnimations({ _ in
            if let nextFocusedItem = context.nextFocusedItem as? TextCell {
                let duration = UIView.inheritedAnimationDuration
                UIView.animate(withDuration: (0.65 * duration),
                               delay: 0.0,
                               options: UIView.AnimationOptions.overrideInheritedDuration,
                               animations: {
                    nextFocusedItem.focusableBackgroundView.transform = CGAffineTransform(scaleX: 1.23, y: 1.23)
                    nextFocusedItem.setFocusedState()
                })
            }
        }, completion: nil)
    }

    func setFocusedState() {
        focusableBackgroundView.layer.borderColor = UIColor.clear.cgColor
        focusableBackgroundView.layer.borderWidth = 0
        focusableBackgroundView.addGradient(gradientOwner: .textCell)
        setTitleFont(for: titleLabel, focused: true)
    }

    // MARK: - Focusing animations
    func performUnfocusingAnimations(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedUnfocusingAnimations({ _ in
            if let previouslyFocusedItem = context.previouslyFocusedItem as? TextCell {
                let duration = UIView.inheritedAnimationDuration
                UIView.animate(withDuration: (0.65 * duration),
                               delay: 0.0,
                               options: UIView.AnimationOptions.overrideInheritedDuration,
                               animations: {
                    previouslyFocusedItem.focusableBackgroundView.transform = .identity
                    previouslyFocusedItem.setUnfocusedState()
                })
            }
        }, completion: nil)
    }

    func setUnfocusedState() {
        focusableBackgroundView.layer.borderColor = UIColor.grey23.cgColor
        focusableBackgroundView.layer.borderWidth = 1
        focusableBackgroundView.removeAllGradientLayers()
        setTitleFont(for: titleLabel, focused: false)
    }

    func setTitleFont(for label: UILabel, focused: Bool) {
        let fontSize: CGFloat = focused ? 26 : 24
        label.font = UIFont.jakarta(font: .display, ofSize: fontSize, weight: .medium)
    }
}
