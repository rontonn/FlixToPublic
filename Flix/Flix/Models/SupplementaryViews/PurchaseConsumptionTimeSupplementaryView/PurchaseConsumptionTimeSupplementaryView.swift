//
//  PurchaseConsumptionTimeSupplementaryView.swift
//  Flix
//
//  Created by Anton Romanov on 09.11.2021.
//

import UIKit

final class PurchaseConsumptionTimeSupplementaryView: UICollectionReusableView {
    static let reuseID = "PurchaseConsumptionTimeSupplementaryView"
    static let cellNibName = UINib(nibName: PurchaseConsumptionTimeSupplementaryView.reuseID, bundle: nil)

    // MARK: - Outlets
    @IBOutlet private weak var accessoryImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        accessoryImageView.image = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
    }

    // MARK: - Public methods
    func setup(_ header: Header) {
        titleLabel.text = header.title
        subtitleLabel.text = header.subtitle
        accessoryImageView.image = header.accessoryImage
    }
}

// MARK: - Private methods
private extension PurchaseConsumptionTimeSupplementaryView {
    func configure() {
        accessoryImageView.contentMode = .scaleAspectFit
        accessoryImageView.image = nil

        titleLabel.font = .jakarta(font: .display, ofSize: 42, weight: .bold)
        titleLabel.textColor = .peachE57

        subtitleLabel.font = .jakarta(font: .display, ofSize: 32, weight: .regular)
        subtitleLabel.textColor = .white.withAlphaComponent(0.6)
    }
}

extension PurchaseConsumptionTimeSupplementaryView {
    struct Header {
        let title: String?
        let subtitle: String?
        let accessoryImage: UIImage?
    }
}
