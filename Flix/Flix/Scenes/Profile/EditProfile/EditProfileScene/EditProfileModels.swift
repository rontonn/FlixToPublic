//
//  
//  EditProfileModels.swift
//  Flix
//
//  Created by Anton Romanov on 03.11.2021.
//
//

import UIKit

enum EditProfileModels {
    // MARK: - InitialData
    enum InitialData {
        struct Request {}
        struct Response {
            let editProfileOptions: [EditProfileData]
        }
        struct ViewModel {
            let leadingPadding: CGFloat
            let topPadding: CGFloat
            let dataSourceSnapshot: NSDiffableDataSourceSnapshot<UUID, UUID>
            let layout: UICollectionViewLayout
        }
    }

    // MARK: - CollectionData
    enum CollectionData {
        struct Request {
            let object: AnyObject?
            let indexPath: IndexPath
        }
        struct Response {
            let object: AnyObject?
            let editProfileData: EditProfileData
        }
        struct ViewModel {
            let object: AnyObject?
            let editProfileData: EditProfileData
        }
    }

    // MARK: - UpdatedData
    enum UpdatedData {
        struct Request {}
        struct Response {}
        struct ViewModel {
            let section: UUID
        }
    }

    // MARK: - FocusUpdated
    enum FocusUpdated {
        struct Request {
            let editProfileData: EditProfileData?
        }
        struct Response {
            let option: EditProfileData.Option?
        }
        struct ViewModel {}
    }
}
