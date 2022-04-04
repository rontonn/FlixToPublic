//
//  HomeSceneTabsCollectionLayoutSource.swift
//  Flix
//
//  Created by Anton Romanov on 22.11.2021.
//

import UIKit

struct HomeSceneTabsCollectionLayoutSource {
}

// MARK: - CollectionViewLayoutHelper
extension HomeSceneTabsCollectionLayoutSource: CollectionViewLayoutHelper {
    var collectionGroupDataSource: CollectionGroupDataSource {
        return self
    }
}

// MARK: - CollectionGroupDataSource
extension HomeSceneTabsCollectionLayoutSource: CollectionGroupDataSource {
    var groupOrientation: GroupOrientation {
        return .vertical
    }

    func interGroupSpacing(_ sectionIndex: Int) -> CGFloat? {
        return 59.0
    }

    var contentInsets: NSDirectionalEdgeInsets {
        return NSDirectionalEdgeInsets(top: 30, leading: 0, bottom: 30, trailing: 0)
    }

    func groupSizeFor(_ sectionIndex: Int) -> NSCollectionLayoutSize? {
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(66.0))
        return groupSize
    }
}
