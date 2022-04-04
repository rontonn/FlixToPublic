//
//  TvChannelCell.swift
//  Flix
//
//  Created by Anton Romanov on 01.11.2021.
//

import UIKit

final class TvChannelCell: UICollectionViewCell {
    static let cellNibName = UINib(nibName: "TvChannelCell", bundle: nil)

    // MARK: - Outlets
    @IBOutlet private weak var gradientView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - Properties
    private var category: TvChannelItem.Category?
    private let cellCornerRadius: CGFloat = 20

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    override func prepareForReuse() {
        category = nil
        titleLabel.text = nil
        setUnfocusedState()
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        performUnfocusingAnimations(in: context, with: coordinator)
        performFocusingAnimations(in: context, with: coordinator)
    }

    // MARK: - Public methods
    func setChannel(_ item: TvChannelItem) {
        titleLabel.attributedText = item.category.title
        category = item.category
    }
}

// MARK: - Private methods
private extension TvChannelCell {
    func configure() {
        gradientView.layer.cornerRadius = cellCornerRadius
        gradientView.clipsToBounds = true
        contentView.layer.cornerRadius = cellCornerRadius
        contentView.clipsToBounds = true
        setUnfocusedState()
    }

    // MARK: - Unfocusing animations
    func performFocusingAnimations(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedFocusingAnimations({ _ in
            if let nextFocusedItem = context.nextFocusedItem as? TvChannelCell {
                let duration = UIView.inheritedAnimationDuration
                UIView.animate(withDuration: (0.75 * duration),
                               delay: 0.0,
                               options: UIView.AnimationOptions.overrideInheritedDuration,
                               animations: {
                    nextFocusedItem.gradientView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                    nextFocusedItem.setFocusedState()
                })
            }
        }, completion: nil)
    }

    func setFocusedState() {
        if let category = category {
            gradientView.addGradient(gradientOwner: .trendingChannel(item: category))
        }
    }

    // MARK: - Focusing animations
    func performUnfocusingAnimations(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedUnfocusingAnimations({ _ in
            if let previouslyFocusedItem = context.previouslyFocusedItem as? TvChannelCell {
                let duration = UIView.inheritedAnimationDuration
                UIView.animate(withDuration: (0.75 * duration),
                               delay: 0.0,
                               options: UIView.AnimationOptions.overrideInheritedDuration,
                               animations: {
                    previouslyFocusedItem.gradientView.transform = .identity
                    previouslyFocusedItem.setUnfocusedState()
                })
            }
        }, completion: nil)
    }

    func setUnfocusedState() {
        gradientView.removeAllGradientLayers()
    }
}
