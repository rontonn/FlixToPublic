//
//  
//  SignInModels.swift
//  FlixAR
//
//  Created by Anton Romanov on 13.10.2021.
//
//

import UIKit

enum SignInModels {
    // MARK: - InitialData
    enum InitialData {
        struct Request {}
        struct Response {
            let signInOptions: [SignInOption]
        }
        struct ViewModel {
            let pageTitle: String
            let dataSourceSnapshot: NSDiffableDataSourceSnapshot<UUID, UUID>
            let layout: UICollectionViewLayout
        }
    }

    // MARK: - SignInOptionData
    enum SignInOptionData {
        struct Request {
            let object: AnyObject?
            let indexPath: IndexPath
        }
        struct Response {
            let object: AnyObject?
            let signInOption: SignInOption
        }
        struct ViewModel {
            let object: AnyObject?
            let signInOption: SignInOption
        }
    }

    // MARK: - SelectSignInOption
    enum SelectSignInOption {
        struct Request {
            let indexPath: IndexPath
        }
        struct Response {
            let option: SignInOption.Option
        }
        struct ViewModel {}
    }
}
