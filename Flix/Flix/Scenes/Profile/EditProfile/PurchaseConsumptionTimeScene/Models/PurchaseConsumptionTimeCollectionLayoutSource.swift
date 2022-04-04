//
//  PurchaseConsumptionTimeCollectionLayoutSource.swift
//  Flix
//
//  Created by Anton Romanov on 22.11.2021.
//

import UIKit

struct PurchaseConsumptionTimeCollectionLayoutSource {
}

// MARK: - CollectionViewLayoutHelper
extension PurchaseConsumptionTimeCollectionLayoutSource: CollectionViewLayoutHelper {
    var collectionGroupDataSource: CollectionGroupDataSource {
        return self
    }

    var collectionHeaderDataSource: CollectionHeaderDataSource? {
        return self
    }
}

// MARK: - CollectionHeaderDataSource {
extension PurchaseConsumptionTimeCollectionLayoutSource: CollectionHeaderDataSource {
    var headerContentInsets: NSDirectionalEdgeInsets {
        return NSDirectionalEdgeInsets(top: 0, leading: -35, bottom: 0, trailing: 0)
    }

    func headerSizeFor(_ sectionIndex: Int) -> NSCollectionLayoutSize? {
        let hSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                           heightDimension: .absolute(200.0))
        return hSize
    }
}

// MARK: - CollectionGroupDataSource
extension PurchaseConsumptionTimeCollectionLayoutSource: CollectionGroupDataSource {
    var groupOrientation: GroupOrientation {
        return .horizontal
    }

    var orthogonalScrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior {
        return .continuousGroupLeadingBoundary
    }

    func interGroupSpacing(_ sectionIndex: Int) -> CGFloat? {
        return 46.0
    }

    var contentInsets: NSDirectionalEdgeInsets {
        return NSDirectionalEdgeInsets(top: 0, leading: 135, bottom: 0, trailing: 80)
    }

    func groupSizeFor(_ sectionIndex: Int) -> NSCollectionLayoutSize? {
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(346.0),
                                               heightDimension: .absolute(400.0))
        return groupSize
    }
}
