//
//  
//  VideoOnDemandDetailsModels.swift
//  Flix
//
//  Created by Anton Romanov on 21.10.2021.
//
//

import UIKit

enum VideoOnDemandDetailsModels {
    // MARK: - InitialData
    enum InitialData {
        struct Request {}
        struct Response {
            let videoOnDemandItem: VideoOnDemandItemDetails?
            let actions: [VideoOnDemandDetailsAction]
        }
        struct ViewModel {
            let dataSourceSnapshot: NSDiffableDataSourceSnapshot<UUID, UUID>
            let layout: UICollectionViewLayout
            let videoOnDemandItem: VideoOnDemandItemDetails?
        }
    }

    // MARK: - Action
    enum Action {
        struct Request {
            let object: AnyObject?
            let indexPath: IndexPath
        }
        struct Response {
            let object: AnyObject?
            let action: VideoOnDemandDetailsAction
        }
        struct ViewModel {
            let object: AnyObject?
            let action: VideoOnDemandDetailsAction
        }
    }

    // MARK: - MoreEpisodesData
    enum SelectVideoOnDemandDetailsAction {
        struct Request {
            let indexPath: IndexPath
        }
        struct Response {
            let option: VideoOnDemandDetailsAction.Option
        }
        struct ViewModel {}
    }
}
