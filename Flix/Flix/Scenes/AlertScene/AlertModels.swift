//
//  
//  AlertModels.swift
//  Flix
//
//  Created by Anton Romanov on 11.11.2021.
//
//

import UIKit

enum AlertModels {
    // MARK: - InitialData
    enum InitialData {
        struct Request {}
        struct Response {
            let info: Info
            let actions: [AlertAction]
        }
        struct ViewModel {
            let info: Info
            let dataSourceSnapshot: NSDiffableDataSourceSnapshot<UUID, UUID>
            let layout: UICollectionViewLayout
        }
    }

    // MARK: - AlertAction
    enum AlertActionData {
        struct Request {
            let object: AnyObject?
            let indexPath: IndexPath
        }
        struct Response {
            let object: AnyObject?
            let action: AlertAction
        }
        struct ViewModel {
            let object: AnyObject?
            let title: String
        }
    }

    // MARK: - SelectAlertAction
    enum SelectAlertAction {
        struct Request {
            let indexPath: IndexPath
        }
        struct Response {
            let action: AlertAction
        }
        struct ViewModel {}
    }
}

extension AlertModels {
    struct Info {
        let image: UIImage?
        let title: String
        let subtitle: String?
    }
}
