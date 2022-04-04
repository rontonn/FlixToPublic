//
//  EditProfileCollectionLayoutSource.swift
//  Flix
//
//  Created by Anton Romanov on 22.11.2021.
//

import UIKit

struct EditProfileCollectionLayoutSource {
}

// MARK: - CollectionViewLayoutHelper
extension EditProfileCollectionLayoutSource: CollectionViewLayoutHelper {
    var collectionGroupDataSource: CollectionGroupDataSource {
        return self
    }

    var collectionHeaderDataSource: CollectionHeaderDataSource? {
        return self
    }
}

// MARK: - CollectionHeaderDataSource
extension EditProfileCollectionLayoutSource: CollectionHeaderDataSource {
    var headerContentInsets: NSDirectionalEdgeInsets {
        return NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 0)
    }

    func headerSizeFor(_ sectionIndex: Int) -> NSCollectionLayoutSize? {
        return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                      heightDimension: .absolute(135.0))
    }
}

// MARK: - CollectionGroupDataSource
extension EditProfileCollectionLayoutSource: CollectionGroupDataSource {
    var groupOrientation: GroupOrientation {
        return .vertical
    }

    func interGroupSpacing(_ sectionIndex: Int) -> CGFloat? {
        return 13.0
    }

    func groupSizeFor(_ sectionIndex: Int) -> NSCollectionLayoutSize? {
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(68.0))
        return groupSize
    }
}
