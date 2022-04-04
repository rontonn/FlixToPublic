//
//  MoreEpisodesSeriesCollectionLayoutSource.swift
//  Flix
//
//  Created by Anton Romanov on 22.11.2021.
//

import UIKit

struct MoreEpisodesSeriesCollectionLayoutSource {
    // MARK: = Properties
    private let numberOfItemsInRow: CGFloat = 3.5
}

// MARK: - CollectionViewLayoutHelper
extension MoreEpisodesSeriesCollectionLayoutSource: CollectionViewLayoutHelper {
    var itemSize: NSCollectionLayoutSize {
        let iSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                            heightDimension: .estimated(410.0))
        return iSize
    }
    var collectionGroupDataSource: CollectionGroupDataSource {
        return self
    }
}

// MARK: - CollectionGroupDataSource
extension MoreEpisodesSeriesCollectionLayoutSource: CollectionGroupDataSource {
    var groupOrientation: GroupOrientation {
        return .horizontal
    }

    var orthogonalScrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior {
        return .continuous
    }

    func interGroupSpacing(_ sectionIndex: Int) -> CGFloat? {
        return 44.0
    }

    func groupSizeFor(_ sectionIndex: Int) -> NSCollectionLayoutSize? {
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / numberOfItemsInRow),
                                               heightDimension: .absolute(410.0))
        return groupSize
    }
}
