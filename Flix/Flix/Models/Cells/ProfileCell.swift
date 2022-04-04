//
//  ProfileCell.swift
//  Flix
//
//  Created by Anton Romanov on 02.11.2021.
//

import UIKit

final class ProfileCell: UICollectionViewCell {
    // MARK: - Properties
    private let focusableBackgroundView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
        v.layer.cornerRadius = 27
        v.clipsToBounds = true
        return v
    }()
    private let actionLabel: UILabel = {
        let t = UILabel()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.adjustsFontForContentSizeCategory = true
        t.backgroundColor = .clear
        t.textColor = .white.withAlphaComponent(0.7)
        t.textAlignment = .center
        return t
    }()
    private let profileImageView: UIImageView = {
        let u = UIImageView()
        u.translatesAutoresizingMaskIntoConstraints = false
        u.backgroundColor = .clear
        u.contentMode = .scaleAspectFit
        return u
    }()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        actionLabel.text = nil
        profileImageView.image = nil
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        performUnfocusingAnimations(in: context, with: coordinator)
        performFocusingAnimations(in: context, with: coordinator)
    }

    // MARK: - Public methods
    func setContent(for profile: Profile) {
        actionLabel.text = profile.action.title
        switch profile.action {
        case .logout:
            profileImageView.image = #imageLiteral(resourceName: "logoutIcon")
            NSLayoutConstraint.activate([profileImageView.widthAnchor.constraint(equalToConstant: 110),
                                         profileImageView.heightAnchor.constraint(equalToConstant: 98)])
        case .edit:
            let size = CGSize(width: 150, height: 150)
            NSLayoutConstraint.activate([profileImageView.widthAnchor.constraint(equalToConstant: size.width),
                                         profileImageView.heightAnchor.constraint(equalToConstant: size.height)])
            profileImageView.clipsToBounds = true
            profileImageView.layer.cornerRadius = size.height / 2
            profileImageView.layer.borderColor = UIColor.white.cgColor
            profileImageView.layer.borderWidth = 6
            if let profileImage = profile.profileImage {
                Task {
                    profileImageView.image = #imageLiteral(resourceName: "defaultProfileImage")
                    if let profileImage = try? await ImageLoadingWorker.fetchImage(profileImage, size: size) {
                        profileImageView.image = profileImage
                    }
                }
            }
        }
    }
}

// MARK: - Private methods
private extension ProfileCell {
    func configure() {
        
        contentView.addSubview(focusableBackgroundView)
        contentView.addSubview(profileImageView)
        contentView.addSubview(actionLabel)

        NSLayoutConstraint.activate([focusableBackgroundView.topAnchor.constraint(equalTo: topAnchor),
                                     focusableBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
                                     focusableBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
                                     focusableBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor)])

        NSLayoutConstraint.activate([actionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                                     actionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -38),
                                     actionLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 10),
                                     actionLabel.trailingAnchor.constraint(greaterThanOrEqualTo: trailingAnchor, constant: -10)])

        NSLayoutConstraint.activate([profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                                     profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor)])
        
        setUnfocusedState()
    }

    // MARK: - Unfocusing animations
    func performFocusingAnimations(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedFocusingAnimations({ _ in
            if let nextFocusedItem = context.nextFocusedItem as? ProfileCell {
                let duration = UIView.inheritedAnimationDuration
                UIView.animate(withDuration: (0.85 * duration),
                               delay: 0.0,
                               options: UIView.AnimationOptions.overrideInheritedDuration,
                               animations: {
                    nextFocusedItem.focusableBackgroundView.transform = CGAffineTransform(scaleX: 1.21, y: 1.21)
                    nextFocusedItem.profileImageView.transform = CGAffineTransform(scaleX: 1.21, y: 1.21)
                    nextFocusedItem.actionLabel.transform = CGAffineTransform(translationX: 0, y: 25)
                    nextFocusedItem.setFocusedState()
                })
            }
        }, completion: nil)
    }

    func setFocusedState() {
        focusableBackgroundView.backgroundColor = .grey130
        focusableBackgroundView.layer.borderColor = UIColor.orange878.cgColor
        focusableBackgroundView.layer.borderWidth = 1
        focusableBackgroundView.addGradient(gradientOwner: .profileCell)
        setTitleFont(for: actionLabel, focused: true)
    }

    // MARK: - Focusing animations
    func performUnfocusingAnimations(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedUnfocusingAnimations({ _ in
            if let previouslyFocusedItem = context.previouslyFocusedItem as? ProfileCell {
                let duration = UIView.inheritedAnimationDuration
                UIView.animate(withDuration: (0.85 * duration),
                               delay: 0.0,
                               options: UIView.AnimationOptions.overrideInheritedDuration,
                               animations: {
                    previouslyFocusedItem.focusableBackgroundView.transform = .identity
                    previouslyFocusedItem.profileImageView.transform = .identity
                    previouslyFocusedItem.actionLabel.transform = .identity
                    previouslyFocusedItem.setUnfocusedState()
                })
            }
        }, completion: nil)
    }

    func setUnfocusedState() {
        focusableBackgroundView.backgroundColor = .grey026
        focusableBackgroundView.layer.borderColor = UIColor.clear.cgColor
        focusableBackgroundView.layer.borderWidth = 0
        focusableBackgroundView.removeAllGradientLayers()
        setTitleFont(for: actionLabel, focused: false)
    }

    func setTitleFont(for label: UILabel, focused: Bool) {
        let fontSize: CGFloat = focused ? 25 : 21
        label.font = UIFont.jakarta(font: .display, ofSize: fontSize, weight: .medium)
    }
}
