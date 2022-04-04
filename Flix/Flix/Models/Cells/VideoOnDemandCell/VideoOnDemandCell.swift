//
//  VideoOnDemandCell.swift
//  Flix
//
//  Created by Anton Romanov on 18.10.2021.
//

import UIKit

final class VideoOnDemandCell: UICollectionViewCell {
    static let cellNibName = UINib(nibName: "VideoOnDemandCell", bundle: nil)

    // MARK: - Outlets
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var ratingOwnerLabel: UILabel!
    @IBOutlet private weak var tagContainerView: UIView!
    @IBOutlet private weak var tagLabel: UILabel!
    @IBOutlet private weak var ratingValueLabel: UILabel!
    @IBOutlet private weak var firstStarImageView: UIImageView!
    @IBOutlet private weak var secondStarImageView: UIImageView!
    @IBOutlet private weak var thirdStarImageView: UIImageView!
    @IBOutlet private weak var fourthtarImageView: UIImageView!
    @IBOutlet private weak var fifthStarImageView: UIImageView!
    

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    override func prepareForReuse() {
        titleLabel.text = nil
        ratingOwnerLabel.text = nil
        ratingValueLabel.text = nil
        posterImageView.image = nil
        tagContainerView.isHidden = true
        tagLabel.text = nil
        resetRatingStars()
        setUnfocusedState()
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        performUnfocusingAnimations(in: context, with: coordinator)
        performFocusingAnimations(in: context, with: coordinator)
    }

    // MARK: - Public methods
    func setVideoItem(_ item: VideoOnDemandItem) {
        titleLabel.text = item.title
        posterImageView.image = item.poster
        ratingOwnerLabel.text = item.ratingOwner
        if let tag = item.tag {
            tagContainerView.isHidden = false
            tagContainerView.backgroundColor = tag.associatedColor
            tagLabel.text = tag.title
        } else {
            tagContainerView.isHidden = true
        }
        updateRatingStars(for: item.ratingValue)
    }
}

// MARK: - Private methods
private extension VideoOnDemandCell {
    func configure() {
        contentView.layer.cornerRadius = 22
        posterImageView.layer.cornerRadius = 20
        tagContainerView.layer.cornerRadius = 4
        resetRatingStars()
        setUnfocusedState()
    }

    // MARK: - Unfocusing animations
    func performFocusingAnimations(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedFocusingAnimations({ _ in
            if let nextFocusedItem = context.nextFocusedItem as? VideoOnDemandCell {
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
        contentView.backgroundColor = .grey130
        posterImageView.layer.borderWidth = 5
        posterImageView.layer.borderColor = UIColor.orange878.cgColor
    }

    // MARK: - Focusing animations
    func performUnfocusingAnimations(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedUnfocusingAnimations({ _ in
            if let previouslyFocusedItem = context.previouslyFocusedItem as? VideoOnDemandCell {
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
        contentView.backgroundColor = .grey026
        posterImageView.layer.borderWidth = 0
        posterImageView.layer.borderColor = UIColor.clear.cgColor
    }

    func updateRatingStars(for rating: Float) {
        let formattedRatingValue: Float
        switch rating {
        case 0.5..<1:
            firstStarImageView.image = #imageLiteral(resourceName: "halfRateStar")
            formattedRatingValue = 0.5
        case 1..<1.5:
            firstStarImageView.image = #imageLiteral(resourceName: "fullRateStar")
            formattedRatingValue = 1.0
        case 1.5..<2:
            firstStarImageView.image = #imageLiteral(resourceName: "fullRateStar")
            secondStarImageView.image = #imageLiteral(resourceName: "halfRateStar")
            formattedRatingValue = 1.5
        case 2..<2.5:
            firstStarImageView.image = #imageLiteral(resourceName: "fullRateStar")
            secondStarImageView.image = #imageLiteral(resourceName: "fullRateStar")
            formattedRatingValue = 2.0
        case 2.5..<3:
            firstStarImageView.image = #imageLiteral(resourceName: "fullRateStar")
            secondStarImageView.image = #imageLiteral(resourceName: "fullRateStar")
            thirdStarImageView.image = #imageLiteral(resourceName: "halfRateStar")
            formattedRatingValue = 2.5
        case 3..<3.5:
            firstStarImageView.image = #imageLiteral(resourceName: "fullRateStar")
            secondStarImageView.image = #imageLiteral(resourceName: "fullRateStar")
            thirdStarImageView.image = #imageLiteral(resourceName: "fullRateStar")
            formattedRatingValue = 3.0
        case 3.5..<4:
            firstStarImageView.image = #imageLiteral(resourceName: "fullRateStar")
            secondStarImageView.image = #imageLiteral(resourceName: "fullRateStar")
            thirdStarImageView.image = #imageLiteral(resourceName: "fullRateStar")
            fourthtarImageView.image = #imageLiteral(resourceName: "halfRateStar")
            formattedRatingValue = 3.5
        case 4..<4.5:
            firstStarImageView.image = #imageLiteral(resourceName: "fullRateStar")
            secondStarImageView.image = #imageLiteral(resourceName: "fullRateStar")
            thirdStarImageView.image = #imageLiteral(resourceName: "fullRateStar")
            fourthtarImageView.image = #imageLiteral(resourceName: "fullRateStar")
            formattedRatingValue = 4.0
        case 4.5..<5:
            firstStarImageView.image = #imageLiteral(resourceName: "fullRateStar")
            secondStarImageView.image = #imageLiteral(resourceName: "fullRateStar")
            thirdStarImageView.image = #imageLiteral(resourceName: "fullRateStar")
            fourthtarImageView.image = #imageLiteral(resourceName: "fullRateStar")
            fifthStarImageView.image = #imageLiteral(resourceName: "halfRateStar")
            formattedRatingValue = 4.5
        case let r where r >= 5:
            firstStarImageView.image = #imageLiteral(resourceName: "fullRateStar")
            secondStarImageView.image = #imageLiteral(resourceName: "fullRateStar")
            thirdStarImageView.image = #imageLiteral(resourceName: "fullRateStar")
            fourthtarImageView.image = #imageLiteral(resourceName: "fullRateStar")
            fifthStarImageView.image = #imageLiteral(resourceName: "fullRateStar")
            formattedRatingValue = 5.0
        default:
            formattedRatingValue = 0.0
        }
        ratingValueLabel.text = String(format: "rating_value".localized, String(formattedRatingValue))
    }

    func resetRatingStars() {
        firstStarImageView.image = #imageLiteral(resourceName: "emptyRateStar")
        secondStarImageView.image = #imageLiteral(resourceName: "emptyRateStar")
        thirdStarImageView.image = #imageLiteral(resourceName: "emptyRateStar")
        fourthtarImageView.image = #imageLiteral(resourceName: "emptyRateStar")
        fifthStarImageView.image = #imageLiteral(resourceName: "emptyRateStar")
    }
}
