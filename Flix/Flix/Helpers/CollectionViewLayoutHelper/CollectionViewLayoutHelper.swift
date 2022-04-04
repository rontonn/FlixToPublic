//
//  CollectionViewLayoutHelper.swift
//  Flix
//
//  Created by Anton Romanov on 11.11.2021.
//

import UIKit

enum GroupOrientation {
    case vertical
    case horizontal
}

// MARK: - CollectionViewLayoutHelper
protocol CollectionViewLayoutHelper {
    var itemSize: NSCollectionLayoutSize { get }

    var contentInsets: NSDirectionalEdgeInsets { get }
    var contentInsetsReference: UIContentInsetsReference { get }
    var orthogonalScrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior { get }
    var interSectionSpacing: CGFloat? { get }

    var collectionHeaderDataSource: CollectionHeaderDataSource? { get }
    var collectionGroupDataSource: CollectionGroupDataSource { get }
}

extension CollectionViewLayoutHelper {
    // MARK: - Default implementations
    var itemSize: NSCollectionLayoutSize {
        return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                      heightDimension: .fractionalHeight(1.0))
    }

    var contentInsets: NSDirectionalEdgeInsets {
        return .zero
    }

    var contentInsetsReference: UIContentInsetsReference {
        return .none
    }

    var orthogonalScrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior {
        return .none
    }

    var interSectionSpacing: CGFloat? {
        return nil
    }

    var collectionHeaderDataSource: CollectionHeaderDataSource? {
        return nil
    }

    // MARK: - Protocol implementations
    func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            var section: NSCollectionLayoutSection?

            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            if let group = collectionGroupDataSource.groupFor(item, sectionIndex: sectionIndex) {
                section = NSCollectionLayoutSection(group: group)
            }
            if let section = section {
                setup(section, sectionIndex: sectionIndex)
            }
            return section
        }
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider,
                                                         configuration: configuration)
        return layout
    }
}

// MARK: - Private methods
private extension CollectionViewLayoutHelper {
    var configuration: UICollectionViewCompositionalLayoutConfiguration {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        if let interSectionSpacing = interSectionSpacing {
            config.interSectionSpacing = interSectionSpacing
        }
        return config
    }

    func setup(_ section: NSCollectionLayoutSection, sectionIndex: Int) {
        if let interGroupSpacing = collectionGroupDataSource.interGroupSpacing(sectionIndex) {
            section.interGroupSpacing = interGroupSpacing
        }
        section.contentInsets = contentInsets
        section.orthogonalScrollingBehavior = orthogonalScrollingBehavior
        section.contentInsetsReference = contentInsetsReference
        if let headerItem = collectionHeaderDataSource?.headerItemFor(sectionIndex) {
            section.boundarySupplementaryItems = [headerItem]
        }
    }

}
