//
//  LiveBroadcastsSupplementaryView.swift
//  Flix
//
//  Created by Anton Romanov on 01.11.2021.
//

import UIKit

final class LiveBroadcastsSupplementaryView: UICollectionReusableView {
    static let reuseID = "LiveBroadcastsSupplementaryView"
    static let cellNibName = UINib(nibName: LiveBroadcastsSupplementaryView.reuseID, bundle: nil)

    // MARK: - Outlets
    @IBOutlet private weak var tagImageView: UIImageView!
    @IBOutlet private weak var tagLabel: UILabel!
    @IBOutlet private weak var streamLabel: UILabel!
    @IBOutlet private weak var categoriesLabel: UILabel!
    @IBOutlet private weak var sectionTitleLabel: UILabel!

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        tagImageView.image = nil
        tagLabel.text = nil
        streamLabel.text = nil
        categoriesLabel.text = nil
        sectionTitleLabel.text = nil
    }

    // MARK: - Public methods
    func setup(_ header: TvBroadcastsSection.Header) {
        tagLabel.text = header.tag
        streamLabel.text = header.stream
        categoriesLabel.text = header.categories
        sectionTitleLabel.text = header.title
    }
}

// MARK: - Private methods
private extension LiveBroadcastsSupplementaryView {
    func configure() {
        tagImageView.contentMode = .scaleAspectFill
        tagImageView.image = #imageLiteral(resourceName: "liveTagIcon")
    }
}
