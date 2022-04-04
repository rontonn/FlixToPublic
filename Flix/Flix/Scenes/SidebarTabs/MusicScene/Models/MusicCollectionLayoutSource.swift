//
//  MusicCollectionLayoutSource.swift
//  Flix
//
//  Created by Anton Romanov on 22.11.2021.
//

import UIKit

struct MusicCollectionLayoutSource {
    let numberOfItemsInRow: CGFloat
}

// MARK: - CollectionViewLayoutHelper
extension MusicCollectionLayoutSource: CollectionViewLayoutHelper {
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
        return 51.0
    }
}

// MARK: - CollectionHeaderDataSource
extension MusicCollectionLayoutSource: CollectionHeaderDataSource {
    func headerSizeFor(_ sectionIndex: Int) -> NSCollectionLayoutSize? {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(51.0))
        return headerSize
    }
}

// MARK: - CollectionGroupDataSource
extension MusicCollectionLayoutSource: CollectionGroupDataSource {
    var groupOrientation: GroupOrientation {
        return .horizontal
    }

    func interGroupSpacing(_ sectionIndex: Int) -> CGFloat? {
        return 45.0
    }

    func groupSizeFor(_ sectionIndex: Int) -> NSCollectionLayoutSize? {
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1 / numberOfItemsInRow),
                                               heightDimension: .absolute(372))
        return groupSize
    }
}
