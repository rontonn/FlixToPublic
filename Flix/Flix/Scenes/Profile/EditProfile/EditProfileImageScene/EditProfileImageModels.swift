//
//  
//  EditProfileImageModels.swift
//  Flix
//
//  Created by Anton Romanov on 08.11.2021.
//
//

import UIKit

enum EditProfileImageModels {
    // MARK: - InitialData
    enum InitialData {
        struct Request {}
        struct Response {
            let profileImage: URL?
            let editProfileImageOptions: [EditProfileImageData]
        }
        struct ViewModel {
            let topPadding: CGFloat
            let profileImage: URL?
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
            let editProfileImageOption: EditProfileImageData
        }
        struct ViewModel {
            let object: AnyObject?
            let editProfileImageOption: EditProfileImageData
        }
    }
    // MARK: - UpdatedData
    enum UpdatedData {
        struct Request {}
        struct Response {}
        struct ViewModel {}
    }
    // MARK: - Result
    enum Result {
        struct Request {
            let newProfileImage: URL?
        }
        struct Response {}
        struct ViewModel {}
    }
}
