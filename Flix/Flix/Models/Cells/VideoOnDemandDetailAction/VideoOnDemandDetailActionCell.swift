//
//  VideoOnDemandDetailsActionCell.swift
//  Flix
//
//  Created by Anton Romanov on 22.10.2021.
//

import UIKit

final class VideoOnDemandDetailsActionCell: UICollectionViewCell {
    // MARK: - Properties
    private let tabImageView: UIImageView = {
        let u = UIImageView()
        u.translatesAutoresizingMaskIntoConstraints = false
        u.backgroundColor = .clear
        u.clipsToBounds = true
        u.contentMode = .scaleAspectFit
        u.layer.opacity = 0.6
        return u
    }()
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.jakarta(font: .display, ofSize: 26, weight: .medium)
        l.textAlignment = .left
        l.textColor = .white
        l.layer.opacity = 0.6
        l.numberOfLines = 1
        return l
    }()
    private let focusableBackgroundView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
        v.layer.cornerRadius = 22
        return v
    }()
    
    private let sizeOfMainImage = CGSize(width: 48, height: 48)
    var action: VideoOnDemandDetailsAction? {
        didSet {
            setMainImage(focused: isFocused)
            titleLabel.text = action?.title
        }
    }

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        tabImageView.image = nil
        action = nil
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        performUnfocusingAnimations(in: context, with: coordinator)
        performFocusingAnimations(in: context, with: coordinator)
    }
}

// MARK: - Private methods
private extension VideoOnDemandDetailsActionCell {
    func configure() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(focusableBackgroundView)
        contentView.addSubview(tabImageView)
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([focusableBackgroundView.topAnchor.constraint(equalTo: topAnchor),
                                     focusableBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
                                     focusableBackgroundView.leftAnchor.constraint(equalTo: leftAnchor),
                                     focusableBackgroundView.rightAnchor.constraint(equalTo: rightAnchor)])

        NSLayoutConstraint.activate([tabImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 21),
                                     tabImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                                     tabImageView.widthAnchor.constraint(equalToConstant: sizeOfMainImage.width),
                                     tabImageView.heightAnchor.constraint(equalToConstant: sizeOfMainImage.height)])
        NSLayoutConstraint.activate([titleLabel.leftAnchor.constraint(equalTo: tabImageView.rightAnchor, constant: 21),
                                     titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                                     titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -42)])
        setUnfocusedState()
        setMainImage(focused: false)
    }

    // MARK: - Unfocusing animations
    func performFocusingAnimations(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedFocusingAnimations({ _ in
            if let nextFocusedItem = context.nextFocusedItem as? VideoOnDemandDetailsActionCell {
                let duration = UIView.inheritedAnimationDuration
                UIView.animate(withDuration: (0.75 * duration),
                               delay: 0.0,
                               options: UIView.AnimationOptions.overrideInheritedDuration,
                               animations: {
                    nextFocusedItem.tabImageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                    nextFocusedItem.setFocusedState()
                })
                UIView.transition(with: nextFocusedItem.tabImageView,
                                  duration: 0.75 * duration,
                                  options: .transitionCrossDissolve,
                                  animations: {
                    nextFocusedItem.setMainImage(focused: true)
                }, completion: nil)

            }
        }, completion: nil)
    }

    func setUnfocusedState() {
        titleLabel.layer.opacity = 0.6
        tabImageView.layer.opacity = 0.6
        focusableBackgroundView.backgroundColor = .clear
        focusableBackgroundView.layer.borderColor = UIColor.clear.cgColor
    }

    // MARK: - Focusing animations
    func performUnfocusingAnimations(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedUnfocusingAnimations({ _ in
            if let previouslyFocusedItem = context.previouslyFocusedItem as? VideoOnDemandDetailsActionCell {
                let duration = UIView.inheritedAnimationDuration
                UIView.animate(withDuration: (0.75 * duration),
                               delay: 0.0,
                               options: UIView.AnimationOptions.overrideInheritedDuration,
                               animations: {
                    previouslyFocusedItem.tabImageView.transform = .identity
                    previouslyFocusedItem.setUnfocusedState()
                })
                UIView.transition(with: previouslyFocusedItem.tabImageView,
                                  duration: 0.75 * duration,
                                  options: .transitionCrossDissolve,
                                  animations: {
                    previouslyFocusedItem.setMainImage(focused: false)
                }, completion: nil)
            }
        }, completion: nil)
    }

    func setFocusedState() {
        titleLabel.layer.opacity = 1
        tabImageView.layer.opacity = 1
        focusableBackgroundView.backgroundColor = UIColor.white.withAlphaComponent(0.06)
        focusableBackgroundView.layer.borderColor = UIColor.systemYellow.withAlphaComponent(0.22).cgColor
        focusableBackgroundView.layer.borderWidth = 1
    }

    func setMainImage(focused: Bool) {
        switch action?.option {
        case .play:
            tabImageView.image = focused ? #imageLiteral(resourceName: "playFocused") : #imageLiteral(resourceName: "playUnfocused")
        case .moreEpisodes:
            tabImageView.image = focused ? #imageLiteral(resourceName: "episodesFocused") : #imageLiteral(resourceName: "episodesUnfocused")
        case .watchLater:
            tabImageView.image = focused ? #imageLiteral(resourceName: "clockFocused") : #imageLiteral(resourceName: "clockUnfocused")
        case .rate:
            tabImageView.image = focused ? #imageLiteral(resourceName: "rateFocused") : #imageLiteral(resourceName: "rateUnfocused")
        case .none:
            tabImageView.image = nil
        }
    }
}
