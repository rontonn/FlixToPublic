//
//  VideoOnDemandDetailsCollectionLayoutSource.swift
//  Flix
//
//  Created by Anton Romanov on 22.11.2021.
//

import UIKit

struct VideoOnDemandDetailsCollectionLayoutSource {
    
}

// MARK: - CollectionViewLayoutHelper
extension VideoOnDemandDetailsCollectionLayoutSource: CollectionViewLayoutHelper {
    var itemSize: NSCollectionLayoutSize {
        let tItemSize = NSCollectionLayoutSize(widthDimension: .estimated(400.0),
                                             heightDimension: .fractionalHeight(1.0))
        return tItemSize
    }
    var collectionGroupDataSource: CollectionGroupDataSource {
        self
    }
}

// MARK: - CollectionGroupDataSource
extension VideoOnDemandDetailsCollectionLayoutSource: CollectionGroupDataSource {
    var groupOrientation: GroupOrientation {
        return .horizontal
    }

    var orthogonalScrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior {
        return .continuousGroupLeadingBoundary
    }

    func interGroupSpacing(_ sectionIndex: Int) -> CGFloat? {
        return 17.0
    }

    func groupSizeFor(_ sectionIndex: Int) -> NSCollectionLayoutSize? {
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(400.0),
                                               heightDimension: .fractionalHeight(1.0))
        return groupSize
    }
}
