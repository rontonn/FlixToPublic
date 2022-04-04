//
//  CollectionHeaderDataSource.swift
//  Flix
//
//  Created by Anton Romanov on 22.11.2021.
//

import UIKit

// MARK: - CollectionHeaderDataSource
protocol CollectionHeaderDataSource {
    var headerContentInsets: NSDirectionalEdgeInsets { get }
    func headerSizeFor(_ sectionIndex: Int) -> NSCollectionLayoutSize?
}

extension CollectionHeaderDataSource {
    // MARK: - Default implementations
    var headerContentInsets: NSDirectionalEdgeInsets {
        return .zero
    }

    func headerItemFor(_ sectionIndex: Int) -> NSCollectionLayoutBoundarySupplementaryItem? {
        guard let headerSize = headerSizeFor(sectionIndex) else {
            return nil
        }
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: SupplementaryElementKind.sectionHeader,
                                                                 alignment: .top)
        header.contentInsets = headerContentInsets
        return header
    }
}
