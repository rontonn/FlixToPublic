//
//  MoreEpisodesSeasonsCollectionLayoutSource.swift
//  Flix
//
//  Created by Anton Romanov on 22.11.2021.
//

import UIKit

struct MoreEpisodesSeasonsCollectionLayoutSource {
    // MARK: = Properties
    private let numberOfItemsInRow: CGFloat = 4.5
}

// MARK: - CollectionViewLayoutHelper
extension MoreEpisodesSeasonsCollectionLayoutSource: CollectionViewLayoutHelper {
    var collectionGroupDataSource: CollectionGroupDataSource {
        return self
    }
}

// MARK: - CollectionGroupDataSource
extension MoreEpisodesSeasonsCollectionLayoutSource: CollectionGroupDataSource {
    var groupOrientation: GroupOrientation {
        return .horizontal
    }

    var orthogonalScrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior {
        return .continuous
    }

    func interGroupSpacing(_ sectionIndex: Int) -> CGFloat? {
        return 16.0
    }

    var contentInsets: NSDirectionalEdgeInsets {
        return NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 30)
    }

    func groupSizeFor(_ sectionIndex: Int) -> NSCollectionLayoutSize? {
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / numberOfItemsInRow),
                                               heightDimension: .absolute(84.0))
        return groupSize
    }
}
