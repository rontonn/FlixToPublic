//
//  
//  TvModels.swift
//  Flix
//
//  Created by Anton Romanov on 15.10.2021.
//
//

import UIKit

enum TvModels {
    // MARK: - InitialData
    enum InitialData {
        struct Request {}
        struct Response {
            let sections: [Section]
        }
        struct ViewModel {
            let dataSourceSnapshot: NSDiffableDataSourceSnapshot<UUID, UUID>
            let layout: UICollectionViewLayout
            let leadingPadding: CGFloat
        }
    }

    // MARK: - TvItemData
    enum TvItemData {
        struct Request {
            let object: AnyObject?
            let indexPath: IndexPath
        }
        struct Response {
            let object: AnyObject?
            let indexPath: IndexPath
            let tvSection: Section
        }
        struct ViewModel {
            let object: AnyObject?
            let categoryTile: String?
            let tvBroadcastsSectionHeader: TvBroadcastsSection.Header?
            let tvBroadcastItem: TvBroadcastItem?
            let tvChannelItem: TvChannelItem?
        }
    }

    // MARK: - FocusChangedInTvCollection
    enum FocusChangedInTvCollection {
        struct Request {
            let nextIndexPath: IndexPath
        }
        struct Response {
            let nextIndexPathItem: Int
            let tvSection: TvModels.Section
        }
        struct ViewModel {
            let leadingPadding: CGFloat?
        }
    }

    // MARK: - SelectTvItem
    enum SelectTvItem {
        struct Request {
            let indexPath: IndexPath
        }
        struct Response {}
        struct ViewModel {}
    }
}

extension TvModels {
    enum Section: Hashable {
        case trendingLiveBroadcasts(broadcasts: TvBroadcastsSection)
        case trendingChannels(channels: TvChannelsSection)

        var sectionIndex: Int {
            switch self {
            case .trendingChannels:
                return 1
            case .trendingLiveBroadcasts:
                return 0
            }
        }
        var numberOfItemsInRow: CGFloat {
            switch self {
            case .trendingChannels:
                return 4.2
            case .trendingLiveBroadcasts:
                return 4
            }
        }
        var groupHeight: CGFloat {
            switch self {
            case .trendingChannels:
                return 183
            case .trendingLiveBroadcasts:
                return 400
            }
        }
        var groupSpacing: CGFloat {
            switch self {
            case .trendingChannels:
                return 54
            case .trendingLiveBroadcasts:
                return 43
            }
        }
        var headerHeight: CGFloat {
            switch self {
            case .trendingChannels:
                return 68
            case .trendingLiveBroadcasts:
                return 279
            }
        }
    }
}
