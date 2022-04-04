//
//  SignInCollectionLayoutSource.swift
//  Flix
//
//  Created by Anton Romanov on 22.11.2021.
//

import UIKit

struct SignInCollectionLayoutSource {
}

// MARK: - CollectionViewLayoutHelper
extension SignInCollectionLayoutSource: CollectionViewLayoutHelper {
    var collectionGroupDataSource: CollectionGroupDataSource {
        self
    }
}

// MARK: - CollectionGroupDataSource
extension SignInCollectionLayoutSource: CollectionGroupDataSource {
    var groupOrientation: GroupOrientation {
        return .vertical
    }

    func interGroupSpacing(_ sectionIndex: Int) -> CGFloat? {
        return 25.0
    }

    func groupSizeFor(_ sectionIndex: Int) -> NSCollectionLayoutSize? {
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(68.0))
        return groupSize
    }
}
