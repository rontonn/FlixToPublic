//
//  
//  MoreEpisodesModels.swift
//  Flix
//
//  Created by Anton Romanov on 25.10.2021.
//
//

import UIKit

enum MoreEpisodesModels {
    // MARK: - InitialData
    enum InitialData {
        struct Request {}
        struct Response {
            let title: String?
            let productionInfo: NSMutableAttributedString?
            let genres: String?
        }
        struct ViewModel {
            let title: String?
            let productionInfo: NSMutableAttributedString?
            let genres: String?
        }
    }

    // MARK: - SeasonsData
    enum SeasonsData {
        struct Request {}
        struct Response {
            let seasonSection: SeasonSection
        }
        struct ViewModel {
            let dataSourceSnapshot: NSDiffableDataSourceSnapshot<UUID, UUID>
            let layout: UICollectionViewLayout
        }
    }

    // MARK: - SeriesData
    enum SeriesData {
        struct Request {}
        struct Response {
            let seriesSection: SeriesSection
        }
        struct ViewModel {
            let dataSourceSnapshot: NSDiffableDataSourceSnapshot<UUID, UUID>
            let layout: UICollectionViewLayout
        }
    }

    // MARK: - SeasonData
    enum SeasonData {
        struct Request {
            let object: AnyObject?
            let indexPath: IndexPath
        }
        struct Response {
            let object: AnyObject?
            let season: Season
        }
        struct ViewModel {
            let object: AnyObject?
            let season: Season
        }
    }

    // MARK: - SeriaData
    enum SeriaData {
        struct Request {
            let object: AnyObject?
            let indexPath: IndexPath
        }
        struct Response {
            let object: AnyObject?
            let seria: Seria
        }
        struct ViewModel {
            let object: AnyObject?
            let seria: Seria
        }
    }

    // MARK: - SeasonFocusChange
    enum SeasonFocusChange {
        struct Request {
            let indexPath: IndexPath
        }
        struct Response {
            let seriesIDs: [UUID]
        }
        struct ViewModel {
            let seriesIDs: [UUID]
        }
    }
}
