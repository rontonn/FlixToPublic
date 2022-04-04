//
//  ProfilesCollectionLayoutSource.swift
//  Flix
//
//  Created by Anton Romanov on 22.11.2021.
//

import UIKit

struct ProfilesCollectionLayoutSource {
}

// MARK: - CollectionViewLayoutHelper
extension ProfilesCollectionLayoutSource: CollectionViewLayoutHelper {
    var collectionGroupDataSource: CollectionGroupDataSource {
        return self
    }
}

// MARK: - CollectionGroupDataSource
extension ProfilesCollectionLayoutSource: CollectionGroupDataSource {
    var groupOrientation: GroupOrientation {
        return .horizontal
    }

    var orthogonalScrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior {
        return .groupPagingCentered
    }

    func interGroupSpacing(_ sectionIndex: Int) -> CGFloat? {
        return 50.0
    }

    func groupSizeFor(_ sectionIndex: Int) -> NSCollectionLayoutSize? {
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(236.0),
                                               heightDimension: .absolute(337.0))
        return groupSize
    }
}
