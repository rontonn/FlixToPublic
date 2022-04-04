//
//  TvCollectionLayoutSource.swift
//  Flix
//
//  Created by Anton Romanov on 22.11.2021.
//

import UIKit

struct TvCollectionLayoutSource {
    let sections: [TvModels.Section]
}

// MARK: - CollectionViewLayoutHelper
extension TvCollectionLayoutSource: CollectionViewLayoutHelper {
    var collectionGroupDataSource: CollectionGroupDataSource {
        self
    }

    var collectionHeaderDataSource: CollectionHeaderDataSource? {
        self
    }

    var orthogonalScrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior {
        return .continuousGroupLeadingBoundary
    }

    var contentInsets: NSDirectionalEdgeInsets {
        NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 80)
    }

    var interSectionSpacing: CGFloat? {
        return 67
    }
}

// MARK: - CollectionHeaderDataSource
extension TvCollectionLayoutSource: CollectionHeaderDataSource {
    func headerSizeFor(_ sectionIndex: Int) -> NSCollectionLayoutSize? {
        var headerSize: NSCollectionLayoutSize?
        if let section = sections.first(where: { $0.sectionIndex == sectionIndex }) {
            headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                heightDimension: .estimated(section.headerHeight))
        }
        return headerSize
    }
}

// MARK: - CollectionGroupDataSource
extension TvCollectionLayoutSource: CollectionGroupDataSource {
    var groupOrientation: GroupOrientation {
        return .horizontal
    }

    func interGroupSpacing(_ sectionIndex: Int) -> CGFloat? {
        let groupSpacing = sections.first(where: { $0.sectionIndex == sectionIndex })?.groupSpacing
        return groupSpacing
    }

    func groupSizeFor(_ sectionIndex: Int) -> NSCollectionLayoutSize? {
        var groupSize: NSCollectionLayoutSize?
        if let section = sections.first(where: { $0.sectionIndex == sectionIndex }) {
            groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1 / section.numberOfItemsInRow),
                                               heightDimension: .absolute(section.groupHeight))
        }
        return groupSize
    }
}
