//
//  MusicCell.swift
//  Flix
//
//  Created by Anton Romanov on 27.10.2021.
//

import UIKit

final class MusicCell: UICollectionViewCell {
    static let cellNibName = UINib(nibName: "MusicCell", bundle: nil)

    // MARK: - Outlets
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var tagContainerView: UIView!
    @IBOutlet private weak var tagLabel: UILabel!
    @IBOutlet private weak var artistLabel: UILabel!
    @IBOutlet private weak var albumLabel: UILabel!
    @IBOutlet private weak var gradientContainerView: UIView!

    // MARK: - Properties
    private let cellCornerRadius: CGFloat = 32
    private let posterCornerRadius: CGFloat = 32
    private let posterBorder: CGFloat = 5

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    override func prepareForReuse() {
        titleLabel.text = nil
        artistLabel.text = nil
        albumLabel.text = nil
        posterImageView.image = nil
        tagContainerView.isHidden = true
        tagLabel.text = nil
        setUnfocusedState()
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        performUnfocusingAnimations(in: context, with: coordinator)
        performFocusingAnimations(in: context, with: coordinator)
    }

    // MARK: - Public methods
    func setMusic(_ item: MusicItem) {
        titleLabel.text = item.title
        artistLabel.text = item.artist
        albumLabel.text = item.album
        posterImageView.image = item.poster
        if let tag = item.tag {
            tagContainerView.isHidden = false
            tagContainerView.backgroundColor = tag.associatedColor
            tagLabel.text = tag.title
        } else {
            tagContainerView.isHidden = true
        }
    }
}

// MARK: - Private methods
private extension MusicCell {
    func configure() {
        gradientContainerView.layer.cornerRadius = cellCornerRadius
        gradientContainerView.clipsToBounds = true
        contentView.layer.cornerRadius = cellCornerRadius
        contentView.clipsToBounds = true
        posterImageView.layer.cornerRadius = posterCornerRadius
        posterImageView.contentMode = .scaleAspectFill
        tagContainerView.layer.cornerRadius = 4

        setUnfocusedState()
    }

    // MARK: - Unfocusing animations
    func performFocusingAnimations(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedFocusingAnimations({ _ in
            if let nextFocusedItem = context.nextFocusedItem as? MusicCell {
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
        titleLabel.alpha = 1
        artistLabel.alpha = 1
        posterImageView.layer.borderColor = UIColor.orange878.cgColor
        posterImageView.layer.borderWidth = posterBorder
        posterImageView.layer.cornerRadius = posterCornerRadius

        gradientContainerView.addGradient(gradientOwner: .musicCell)
        
    }

    // MARK: - Focusing animations
    func performUnfocusingAnimations(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedUnfocusingAnimations({ _ in
            if let previouslyFocusedItem = context.previouslyFocusedItem as? MusicCell {
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
        titleLabel.alpha = 0.7
        artistLabel.alpha = 0.7
        albumLabel.alpha = 0.7
        contentView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        posterImageView.layer.borderWidth = 0
        posterImageView.layer.borderColor = UIColor.clear.cgColor

        gradientContainerView.removeAllGradientLayers()
    }
}
