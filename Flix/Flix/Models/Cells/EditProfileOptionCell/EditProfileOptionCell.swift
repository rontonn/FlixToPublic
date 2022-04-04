//
//  EditProfileOptionCell.swift
//  Flix
//
//  Created by Anton Romanov on 03.11.2021.
//

import UIKit

protocol EditProfileOptionCellDelegate: AnyObject {
    func focusUpdated(to editProfileData: EditProfileData?)
}

final class EditProfileOptionCell: UICollectionViewCell {
    static let cellNibName = UINib(nibName: "EditProfileOptionCell", bundle: nil)

    // MARK: - Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var accessoryLabel: UILabel!
    @IBOutlet private weak var accessoryImageView: UIImageView!

    // MARK: - Properties
    private var editProfileData: EditProfileData?
    private weak var delegate: EditProfileOptionCellDelegate?

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    override func prepareForReuse() {
        editProfileData = nil
        titleLabel.text = nil
        accessoryLabel.text = nil
        accessoryImageView.image = nil
        accessoryLabel.isHidden = true
        accessoryImageView.isHidden = true
        setUnfocusedState()
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        performUnfocusingAnimations(in: context, with: coordinator)
        performFocusingAnimations(in: context, with: coordinator)
    }

    // MARK: - Public methods
    func setEdit(_ editProfileData: EditProfileData, delegate: EditProfileOptionCellDelegate?) {
        self.editProfileData = editProfileData
        self.delegate = delegate
        titleLabel.text = editProfileData.title
        switch editProfileData.option {
        case .name(let value):
            accessoryLabel.text = value
        case .profileImage(let value):
            if let value = value {
                accessoryImageView.image = #imageLiteral(resourceName: "defaultProfileImage")
                Task {
                    if let profileImage = try? await ImageLoadingWorker.fetchImage(value) {
                        accessoryImageView.image = profileImage
                    }
                }
                accessoryImageView.layer.borderColor = UIColor.white.cgColor
                accessoryImageView.layer.borderWidth = 1
                accessoryImageView.layer.cornerRadius = 24
            } else {
                accessoryImageView.image = nil
            }
        case .subscriptionPlan(let value):
            accessoryLabel.text = value
        }
    }
}

// MARK: - Private methods
private extension EditProfileOptionCell {
    func configure() {
        contentView.layer.cornerRadius = 35
        contentView.clipsToBounds = true
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.white.withAlphaComponent(0.4).cgColor
        accessoryImageView.contentMode = .scaleAspectFit
        titleLabel.font = UIFont.jakarta(font: .display, ofSize: 22, weight: .regular)
        titleLabel.textColor = .white
        accessoryLabel.font = UIFont.jakarta(font: .display, ofSize: 22, weight: .bold)
        accessoryLabel.textColor = .white.withAlphaComponent(0.6)
        setUnfocusedState()
    }

    // MARK: - Unfocusing animations
    func performFocusingAnimations(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedFocusingAnimations({ _ in
            if let nextFocusedItem = context.nextFocusedItem as? EditProfileOptionCell {
                nextFocusedItem.delegate?.focusUpdated(to: nextFocusedItem.editProfileData)
                let duration = UIView.inheritedAnimationDuration
                UIView.animate(withDuration: (0.85 * duration),
                               delay: 0.0,
                               options: UIView.AnimationOptions.overrideInheritedDuration,
                               animations: {
                    nextFocusedItem.setFocusedState()
                })
            }
        }, completion: nil)
    }

    func setFocusedState() {
        contentView.backgroundColor = .white.withAlphaComponent(0.4)
        contentView.layer.borderColor = UIColor.black.cgColor
    }

    // MARK: - Focusing animations
    func performUnfocusingAnimations(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedUnfocusingAnimations({ _ in
            if let previouslyFocusedItem = context.previouslyFocusedItem as? EditProfileOptionCell {
                let duration = UIView.inheritedAnimationDuration
                UIView.animate(withDuration: (0.85 * duration),
                               delay: 0.0,
                               options: UIView.AnimationOptions.overrideInheritedDuration,
                               animations: {
                    previouslyFocusedItem.setUnfocusedState()
                })
            }
        }, completion: nil)
    }

    func setUnfocusedState() {
        contentView.backgroundColor = .clear
        contentView.layer.borderColor = UIColor.white.withAlphaComponent(0.4).cgColor
    }
}
