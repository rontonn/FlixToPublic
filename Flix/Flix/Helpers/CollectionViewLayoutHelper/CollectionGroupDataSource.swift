//
//  CollectionGroupDataSource.swift
//  Flix
//
//  Created by Anton Romanov on 22.11.2021.
//

import UIKit

// MARK: - CollectionGroupDataSource
protocol CollectionGroupDataSource {
    var groupOrientation: GroupOrientation { get }
    func interGroupSpacing(_ sectionIndex: Int) -> CGFloat?
    func groupSizeFor(_ sectionIndex: Int) -> NSCollectionLayoutSize?
}

extension CollectionGroupDataSource {
    func groupFor(_ item: NSCollectionLayoutItem, sectionIndex: Int) -> NSCollectionLayoutGroup? {
        guard let groupSize = groupSizeFor(sectionIndex) else {
            return nil
        }
        switch groupOrientation {
        case .vertical:
            return NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        case .horizontal:
            return NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        }
    }
}
