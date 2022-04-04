//
//  
//  ErrorModels.swift
//  Flix
//
//  Created by Anton Romanov on 29.10.2021.
//
//

import UIKit

enum ErrorModels {
    // MARK: - InitialData
    enum InitialData {
        struct Request {}
        struct Response {
            let error: PriviError
        }
        struct ViewModel {
            let description: String?
            let image: UIImage?
            let dataSourceSnapshot: NSDiffableDataSourceSnapshot<UUID, UUID>
            let layout: UICollectionViewLayout
        }
    }

    // MARK: - ErrorActionData
    enum ErrorActionData {
        struct Request {
            let object: AnyObject?
            let indexPath: IndexPath
        }
        struct Response {
            let object: AnyObject?
            let action: PriviErrorAction
        }
        struct ViewModel {
            let object: AnyObject?
            let title: String
        }
    }

    // MARK: - SelectErrorAction
    enum SelectErrorAction {
        struct Request {
            let indexPath: IndexPath
        }
        struct Response {
            let action: PriviErrorAction
        }
        struct ViewModel {}
    }
}
