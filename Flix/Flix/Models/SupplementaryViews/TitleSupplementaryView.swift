//
//  TitleSupplementaryView.swift
//  Flix
//
//  Created by Anton Romanov on 18.10.2021.
//

import UIKit

final class TitleSupplementaryView: UICollectionReusableView {
    static let reuseIdentifier = "title-supplementary-reuse-identifier"

    // MARK: - Properties
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.adjustsFontForContentSizeCategory = true
        l.textColor = .white
        return l
    }()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("TitleSupplementaryView 'init(coder:)' has not been implemented.")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }

    // MARK: - Public methods
    func setTitle(_ title: String,
                  font: UIFont = UIFont.jakarta(font: .display, ofSize: 32, weight: .bold)) {
        titleLabel.font = font
        titleLabel.text = title
    }
}

// MARK: - Private methods
private extension TitleSupplementaryView {
    func configure() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
                                     titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
                                     titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0)])
    }
}
