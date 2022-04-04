//
//  SeriaCell.swift
//  Flix
//
//  Created by Anton Romanov on 25.10.2021.
//

import UIKit

final class SeriaCell: UICollectionViewCell {
    static let cellNibName = UINib(nibName: "SeriaCell", bundle: nil)

    // MARK: - Outlets
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var progressView: UIView!
    @IBOutlet private weak var seriaNumberLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    // MARK: - Properties
    private let progressLayer = CALayer()

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    override func prepareForReuse() {
        seriaNumberLabel.text = nil
        durationLabel.text = nil
        titleLabel.text = nil
        descriptionLabel.text = nil
        progressView.backgroundColor = UIColor.grey210.withAlphaComponent(0.6)
        progressLayer.removeFromSuperlayer()
        setUnfocusedState()
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        performUnfocusingAnimations(in: context, with: coordinator)
        performFocusingAnimations(in: context, with: coordinator)
    }

    // MARK: - Public methods
    func setup(_ seria: Seria) {
        let tag = Int.random(in: 1...7)
        posterImageView.image = UIImage(named: "testPoster\(tag)")
        seriaNumberLabel.text = seria.seasonNumber + seria.seriaNumber
        titleLabel.text = seria.seriaTitle
        durationLabel.text = seria.duration
        descriptionLabel.text = seria.description

        layoutIfNeeded()
        let progressWidth = (seria.progress / 100) * progressView.bounds.width
        progressLayer.frame = CGRect(x: 0, y: 0, width: progressWidth, height: 10)
        progressLayer.cornerRadius = 3
        progressLayer.backgroundColor = UIColor.peachE57.cgColor
        progressView.layer.addSublayer(progressLayer)
    }
}

// MARK: - Private methods
private extension SeriaCell {
    func configure() {
        posterImageView.layer.cornerRadius = 17
        progressView.backgroundColor = UIColor.grey210.withAlphaComponent(0.6)
        progressView.layer.cornerRadius = 3
        progressView.layer.masksToBounds = true
        setUnfocusedState()
    }

    // MARK: - Unfocusing animations
    func performFocusingAnimations(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedFocusingAnimations({ _ in
            if let nextFocusedItem = context.nextFocusedItem as? SeriaCell {
                let duration = UIView.inheritedAnimationDuration
                UIView.animate(withDuration: (0.75 * duration),
                               delay: 0.0,
                               options: UIView.AnimationOptions.overrideInheritedDuration,
                               animations: {
                    nextFocusedItem.posterImageView.transform = CGAffineTransform(scaleX: 1.04, y: 1.04)
                    nextFocusedItem.setFocusedState()
                })
            }
        }, completion: nil)
    }

    func setFocusedState() {
        posterImageView.layer.borderColor = UIColor.orange878.cgColor
        posterImageView.layer.borderWidth = 3
        seriaNumberLabel.layer.opacity = 1
        durationLabel.layer.opacity = 1
        titleLabel.layer.opacity = 1
        descriptionLabel.layer.opacity = 1
    }

    // MARK: - Focusing animations
    func performUnfocusingAnimations(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedUnfocusingAnimations({ _ in
            if let previouslyFocusedItem = context.previouslyFocusedItem as? SeriaCell {
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
        posterImageView.layer.borderColor = UIColor.clear.cgColor
        posterImageView.layer.borderWidth = 0
        seriaNumberLabel.layer.opacity = 0.7
        durationLabel.layer.opacity = 0.7
        titleLabel.layer.opacity = 0.7
        descriptionLabel.layer.opacity = 0.7
    }
}
