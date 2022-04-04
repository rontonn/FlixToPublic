//
//  
//  MoviesModels.swift
//  Flix
//
//  Created by Anton Romanov on 15.10.2021.
//
//

import UIKit

enum MoviesModels {
    // MARK: - InitialData
    enum InitialData {
        struct Request {}
        struct Response {
            let movieSections: [VideoOnDemandSection]
        }
        struct ViewModel {
            let dataSourceSnapshot: NSDiffableDataSourceSnapshot<UUID, UUID>
            let layout: UICollectionViewLayout
            let leadingPadding: CGFloat
        }
    }

    // MARK: - MovieData
    enum MovieData {
        struct Request {
            let object: AnyObject?
            let indexPath: IndexPath
        }
        struct Response {
            let object: AnyObject?
            let categoryTile: String?
            let movie: VideoOnDemandItem?
        }
        struct ViewModel {
            let object: AnyObject?
            let categoryTile: String?
            let movie: VideoOnDemandItem?
        }
    }

    // MARK: - FocusChangedInMoviesCollection
    enum FocusChangedInMoviesCollection {
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

    // MARK: - SelectMovie
    enum SelectMovie {
        struct Request {
            let indexPath: IndexPath
        }
        struct Response {}
        struct ViewModel {}
    }
}
