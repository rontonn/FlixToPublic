//
//  SeasonCell.swift
//  Flix
//
//  Created by Anton Romanov on 25.10.2021.
//

import UIKit

final class SeasonCell: UICollectionViewCell {
    static let cellNibName = UINib(nibName: "SeasonCell", bundle: nil)

    // MARK: - Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    override func prepareForReuse() {
        titleLabel.text = nil
        subtitleLabel.text = nil
        setUnfocusedState()
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        performUnfocusingAnimations(in: context, with: coordinator)
        performFocusingAnimations(in: context, with: coordinator)
    }

    // MARK: - Public methods
    func setup(_ season: Season) {
        titleLabel.text = season.title
        subtitleLabel.text = season.subtitle
    }
}

// MARK: - Private methods
private extension SeasonCell {
    func configure() {
        contentView.layer.cornerRadius = 19
        setUnfocusedState()
    }

    // MARK: - Unfocusing animations
    func performFocusingAnimations(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedFocusingAnimations({ _ in
            if let nextFocusedItem = context.nextFocusedItem as? SeasonCell {
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
        contentView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.orange878.cgColor
    }

    // MARK: - Focusing animations
    func performUnfocusingAnimations(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedUnfocusingAnimations({ _ in
            if let previouslyFocusedItem = context.previouslyFocusedItem as? SeasonCell {
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
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.white.withAlphaComponent(0.22).cgColor
    }
}
