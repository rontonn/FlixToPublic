//
//  
//  MusicModels.swift
//  Flix
//
//  Created by Anton Romanov on 15.10.2021.
//
//

import UIKit

enum MusicModels {
    // MARK: - InitialData
    enum InitialData {
        struct Request {}
        struct Response {
            let musicSections: [MusicSection]
        }
        struct ViewModel {
            let dataSourceSnapshot: NSDiffableDataSourceSnapshot<UUID, UUID>
            let layout: UICollectionViewLayout
            let leadingPadding: CGFloat
        }
    }

    // MARK: - MusicItemData
    enum MusicItemData {
        struct Request {
            let object: AnyObject?
            let indexPath: IndexPath
        }
        struct Response {
            let object: AnyObject?
            let categoryTile: String?
            let musicItem: MusicItem?
        }
        struct ViewModel {
            let object: AnyObject?
            let categoryTile: String?
            let musicItem: MusicItem?
        }
    }

    // MARK: - FocusChangedInMusicCollection
    enum FocusChangedInMusicCollection {
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

    // MARK: - SelectMusic
    enum SelectMusic {
        struct Request {
            let indexPath: IndexPath
        }
        struct Response {}
        struct ViewModel {}
    }
}
