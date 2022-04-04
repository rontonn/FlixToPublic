//
//  SceneTabCell.swift
//  Flix
//
//  Created by Anton Romanov on 15.10.2021.
//

import UIKit

protocol SceneTabCellDelegate: AnyObject {
    func focusUpdated(to sceneTab: SceneTab?)
}

final class SceneTabCell: UICollectionViewCell {
    // MARK: - Properties
    private let tabImageView: UIImageView = {
        let u = UIImageView()
        u.translatesAutoresizingMaskIntoConstraints = false
        u.backgroundColor = .clear
        u.clipsToBounds = true
        u.contentMode = .scaleAspectFit
        return u
    }()
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.jakarta(font: .display, ofSize: 24, weight: .medium)
        l.textAlignment = .left
        l.textColor = .white
        l.layer.opacity = 0.6
        return l
    }()
    private let focusableBackgroundView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
        v.layer.opacity = 0.2
        return v
    }()
    
    private let sizeOfMainImage = CGSize(width: 56, height: 56)
    var sceneTab: SceneTab? {
        didSet {
            setMainImage(focused: isFocused)
            titleLabel.text = sceneTab?.title
        }
    }
    weak var delegate: SceneTabCellDelegate?

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
        sceneTab = nil
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        performUnfocusingAnimations(in: context, with: coordinator)
        performFocusingAnimations(in: context, with: coordinator)
    }
}

// MARK: - Private methods
private extension SceneTabCell {
    func configure() {
        contentView.addSubview(focusableBackgroundView)
        contentView.addSubview(tabImageView)
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([focusableBackgroundView.topAnchor.constraint(equalTo: topAnchor),
                                     focusableBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
                                     focusableBackgroundView.leftAnchor.constraint(equalTo: leftAnchor),
                                     focusableBackgroundView.rightAnchor.constraint(equalTo: rightAnchor)])

        NSLayoutConstraint.activate([tabImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
                                     tabImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                                     tabImageView.widthAnchor.constraint(equalToConstant: sizeOfMainImage.width),
                                     tabImageView.heightAnchor.constraint(equalToConstant: sizeOfMainImage.height)])

        NSLayoutConstraint.activate([titleLabel.leftAnchor.constraint(equalTo: tabImageView.rightAnchor, constant: 21),
                                     titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)])
        setUnfocusedState()
        setMainImage(focused: false)
    }

    // MARK: - Unfocusing animations
    func performFocusingAnimations(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedFocusingAnimations({ _ in
            if let nextFocusedItem = context.nextFocusedItem as? SceneTabCell {
                nextFocusedItem.delegate?.focusUpdated(to: nextFocusedItem.sceneTab)
                let duration = UIView.inheritedAnimationDuration
                UIView.animate(withDuration: (0.75 * duration),
                               delay: 0.0,
                               options: UIView.AnimationOptions.overrideInheritedDuration,
                               animations: {
                    nextFocusedItem.tabImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
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
        titleLabel.layer.opacity = 0.7
        focusableBackgroundView.backgroundColor = .clear
    }

    // MARK: - Focusing animations
    func performUnfocusingAnimations(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedUnfocusingAnimations({ _ in
            guard let previouslyFocusedItem = context.previouslyFocusedItem as? SceneTabCell,
                  let nextFocusedItem = context.nextFocusedItem as? SceneTabCell,
                  previouslyFocusedItem !== nextFocusedItem else {
                      return
                  }
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
        }, completion: nil)
    }

    func setFocusedState() {
        titleLabel.layer.opacity = 1
        switch sceneTab?.option {
        case .profile:
            break
        default:
            focusableBackgroundView.backgroundColor = .greyD77
        }
    }

    func setMainImage(focused: Bool) {
        switch sceneTab?.option {
        case .profile(let imageURL):
            if let imageURL = imageURL {
                Task {
                    tabImageView.image = #imageLiteral(resourceName: "defaultProfileImage")
                    if let profileImage = try? await ImageLoadingWorker.fetchImage(imageURL) {
                        tabImageView.image = profileImage
                    }
                }
            } else {
                tabImageView.image = #imageLiteral(resourceName: "guestImage")
            }
            tabImageView.layer.borderColor = focused ? UIColor.redPeach.cgColor : UIColor.white.cgColor
            tabImageView.layer.borderWidth = 2
            tabImageView.layer.cornerRadius = sizeOfMainImage.height / 2
        case .movies:
            tabImageView.image = focused ? #imageLiteral(resourceName: "sceneTabMovieFocused") : #imageLiteral(resourceName: "sceneTabMovie")
        case .series:
            tabImageView.image = focused ? #imageLiteral(resourceName: "sceneTabSeriesFocused") : #imageLiteral(resourceName: "sceneTabSeries")
        case .music:
            tabImageView.image = focused ? #imageLiteral(resourceName: "sceneTabMusicFocused") : #imageLiteral(resourceName: "sceneTabMusic")
        case .tv:
            tabImageView.image = focused ? #imageLiteral(resourceName: "sceneTabTVFocused") : #imageLiteral(resourceName: "sceneTabTV")
        case .none:
            tabImageView.image = nil
        }
    }
}

