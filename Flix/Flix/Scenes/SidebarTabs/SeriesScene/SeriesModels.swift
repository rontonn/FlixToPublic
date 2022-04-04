//
//  
//  SeriesModels.swift
//  Flix
//
//  Created by Anton Romanov on 15.10.2021.
//
//

import UIKit

enum SeriesModels {
    // MARK: - InitialData
    enum InitialData {
        struct Request {}
        struct Response {
            let seriesSections: [VideoOnDemandSection]
        }
        struct ViewModel {
            let dataSourceSnapshot: NSDiffableDataSourceSnapshot<UUID, UUID>
            let layout: UICollectionViewLayout
            let leadingPadding: CGFloat
        }
    }

    // MARK: - SeriesData
    enum SeriesData {
        struct Request {
            let object: AnyObject?
            let indexPath: IndexPath
        }
        struct Response {
            let object: AnyObject?
            let categoryTile: String?
            let series: VideoOnDemandItem?
        }
        struct ViewModel {
            let object: AnyObject?
            let categoryTile: String?
            let series: VideoOnDemandItem?
        }
    }

    // MARK: - FocusChangedInSeriesCollection
    enum FocusChangedInSeriesCollection {
        struct Request {
            let nextIndexPath: IndexPath
        }
        struct Response {
            let nextIndexPathItem: Int
        }
        struct ViewModel {
            let leadingPadding: CGFloat?
        }
    }

    // MARK: - SelectSeries
    enum SelectSeries {
        struct Request {
            let indexPath: IndexPath
        }
        struct Response {}
        struct ViewModel {}
    }
}
