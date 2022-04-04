//
//  PurchaseConsumptionTimeCell.swift
//  Flix
//
//  Created by Anton Romanov on 09.11.2021.
//

import UIKit

final class PurchaseConsumptionTimeCell: UICollectionViewCell {
    static let cellNibName = UINib(nibName: "PurchaseConsumptionTimeCell", bundle: nil)

    // MARK: - Outlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var addLabel: UILabel!
    @IBOutlet private weak var hoursLabel: UILabel!
    @IBOutlet private weak var forPriceLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var rewardLabel: UILabel!
    
    // MARK: - Properties

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    override func prepareForReuse() {
        containerView.backgroundColor = .clear
        addLabel.text = nil
        hoursLabel.text = nil
        priceLabel.text = nil
        forPriceLabel.text = nil
        rewardLabel.text = nil
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        performUnfocusingAnimations(in: context, with: coordinator)
        performFocusingAnimations(in: context, with: coordinator)
    }

    // MARK: - Public methods
    func setup(_ purchaseOption: PurchaseConsumptionTimeOption) {
        hoursLabel.text = purchaseOption.hoursTitle
        priceLabel.text = purchaseOption.priceTitle
        rewardLabel.text = purchaseOption.rewardTile
    }
}

// MARK: - Private methods
private extension PurchaseConsumptionTimeCell {
    func configure() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        addLabel.font = .jakarta(font: .display, ofSize: 37, weight: .bold)
        addLabel.textColor = .white.withAlphaComponent(0.6)
        addLabel.text = "add_title".localized

        hoursLabel.font = .jakarta(font: .display, ofSize: 70, weight: .bold)
        hoursLabel.textColor = .white

        forPriceLabel.font = .jakarta(font: .display, ofSize: 20, weight: .bold)
        forPriceLabel.textColor = .white.withAlphaComponent(0.6)
        forPriceLabel.text = "for_title".localized

        priceLabel.font = .jakarta(font: .display, ofSize: 37, weight: .bold)
        priceLabel.textColor = .white.withAlphaComponent(0.6)
        
        rewardLabel.font = .jakarta(font: .display, ofSize: 24, weight: .bold)
        rewardLabel.textColor = .white.withAlphaComponent(0.6)

        containerView.layer.cornerRadius = 64
        containerView.clipsToBounds = true

        setUnfocusedState()
    }

    // MARK: - Unfocusing animations
    func performFocusingAnimations(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedFocusingAnimations({ _ in
            if let nextFocusedItem = context.nextFocusedItem as? PurchaseConsumptionTimeCell {
                let duration = UIView.inheritedAnimationDuration
                UIView.animate(withDuration: (0.75 * duration),
                               delay: 0.0,
                               options: UIView.AnimationOptions.overrideInheritedDuration,
                               animations: {
                    nextFocusedItem.setFocusedState()
                })
            }
        }, completion: nil)
    }

    func setFocusedState() {
        contentView.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
        containerView.layer.borderWidth = 4
        containerView.layer.borderColor = UIColor.peachE57.cgColor
        containerView.layer.backgroundColor = UIColor.brown737.cgColor
    }

    // MARK: - Focusing animations
    func performUnfocusingAnimations(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedUnfocusingAnimations({ _ in
            if let previouslyFocusedItem = context.previouslyFocusedItem as? PurchaseConsumptionTimeCell {
                let duration = UIView.inheritedAnimationDuration
                UIView.animate(withDuration: (0.75 * duration),
                               delay: 0.0,
                               options: UIView.AnimationOptions.overrideInheritedDuration,
                               animations: {
                    previouslyFocusedItem.setUnfocusedState()
                })
            }
        }, completion: nil)
    }

    func setUnfocusedState() {
        contentView.transform = CGAffineTransform.identity
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.white.withAlphaComponent(0.4).cgColor
        containerView.layer.backgroundColor = UIColor.white.withAlphaComponent(0.07).cgColor
    }
}
