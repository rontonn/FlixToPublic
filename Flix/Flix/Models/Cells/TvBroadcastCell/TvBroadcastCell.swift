//
//  TvBroadcastCell.swift
//  Flix
//
//  Created by Anton Romanov on 01.11.2021.
//

import UIKit

final class TvBroadcastCell: UICollectionViewCell {
    static let cellNibName = UINib(nibName: "TvBroadcastCell", bundle: nil)

    // MARK: - Outlets
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var tagImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    override func prepareForReuse() {
        titleLabel.text = nil
        subtitleLabel.text = nil
        descriptionLabel.text = nil
        posterImageView.image = nil
        tagImageView.image = nil
        setUnfocusedState()
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        performUnfocusingAnimations(in: context, with: coordinator)
        performFocusingAnimations(in: context, with: coordinator)
    }

    // MARK: - Public methods
    func setTvBroadcast(_ item: TvBroadcastItem) {
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        descriptionLabel.text = item.description
        posterImageView.image = item.poster
        if let tag = item.tag {
            tagImageView.isHidden = false
            tagImageView.image = tag.image
        } else {
            tagImageView.isHidden = true
        }
    }
}

// MARK: - Private methods
private extension TvBroadcastCell {
    func configure() {
        posterImageView.layer.cornerRadius = 16
        posterImageView.contentMode = .scaleAspectFill

        setUnfocusedState()
    }

    // MARK: - Unfocusing animations
    func performFocusingAnimations(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedFocusingAnimations({ _ in
            if let nextFocusedItem = context.nextFocusedItem as? TvBroadcastCell {
                let duration = UIView.inheritedAnimationDuration
                UIView.animate(withDuration: (0.75 * duration),
                               delay: 0.0,
                               options: UIView.AnimationOptions.overrideInheritedDuration,
                               animations: {
                    nextFocusedItem.posterImageView.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
                    nextFocusedItem.setFocusedState()
                })
            }
        }, completion: nil)
    }

    func setFocusedState() {
        titleLabel.alpha = 1
        subtitleLabel.alpha = 1
        descriptionLabel.alpha = 1
        posterImageView.layer.borderColor = UIColor.orange878.cgColor
        posterImageView.layer.borderWidth = 4
    }

    // MARK: - Focusing animations
    func performUnfocusingAnimations(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedUnfocusingAnimations({ _ in
            if let previouslyFocusedItem = context.previouslyFocusedItem as? TvBroadcastCell {
                let duration = UIView.inheritedAnimationDuration
                UIView.animate(withDuration: (0.75 * duration),
                               delay: 0.0,
                               options: UIView.AnimationOptions.overrideInheritedDuration,
                               animations: {
                    previouslyFocusedItem.posterImageView.transform = .identity
                    previouslyFocusedItem.setUnfocusedState()
                })
            }
        }, completion: nil)
    }

    func setUnfocusedState() {
        titleLabel.alpha = 0.8
        subtitleLabel.alpha = 0.8
        descriptionLabel.alpha = 0.7
        contentView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        posterImageView.layer.borderWidth = 0
        posterImageView.layer.borderColor = UIColor.clear.cgColor
    }
}
