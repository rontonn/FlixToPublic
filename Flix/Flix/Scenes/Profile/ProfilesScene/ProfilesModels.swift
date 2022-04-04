//
//  
//  ProfilesModels.swift
//  Flix
//
//  Created by Anton Romanov on 02.11.2021.
//
//

import UIKit

enum ProfilesModels {
    // MARK: - InitialData
    enum InitialData {
        struct Request {}
        struct Response {
            let profiles: [Profile]
        }
        struct ViewModel {
            let dataSourceSnapshot: NSDiffableDataSourceSnapshot<UUID, UUID>
            let layout: UICollectionViewLayout
        }
    }

    // MARK: - ProfileData
    enum ProfileData {
        struct Request {
            let object: AnyObject?
            let indexPath: IndexPath
        }
        struct Response {
            let object: AnyObject?
            let profile: Profile
        }
        struct ViewModel {
            let object: AnyObject?
            let profile: Profile
        }
    }

    // MARK: - EditProfile
    enum EditProfile {
        struct Request {
            let indexPath: IndexPath
        }
        struct Response {
        }
        struct ViewModel {
        }
    }
}
