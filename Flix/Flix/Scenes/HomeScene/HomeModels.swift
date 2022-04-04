//
//  
//  HomeModels.swift
//  FlixAR
//
//  Created by Anton Romanov on 12.10.2021.
//
//

import UIKit

enum HomeModels {
    // MARK: - InitialData
    enum InitialData {
        struct Request {}
        struct Response {
            let sceneTabs: [SceneTab]
        }
        struct ViewModel {
            let dataSourceSnapshot: NSDiffableDataSourceSnapshot<UUID, UUID>
            let layout: UICollectionViewLayout
        }
    }

    // MARK: - SceneTabData
    enum SceneTabData {
        struct Request {
            let object: AnyObject?
            let indexPath: IndexPath
        }
        struct Response {
            let object: AnyObject?
            let sceneTab: SceneTab
        }
        struct ViewModel {
            let object: AnyObject?
            let sceneTab: SceneTab
        }
    }

    // MARK: - SelectHomeTab
    enum SelectHomeTab {
        struct Request {
            let indexPath: IndexPath
        }
        struct Response {
            let sceneTab: SceneTab
        }
        struct ViewModel {
            let sceneTab: SceneTab
        }
    }

    // MARK: - SideBarAppearance
    enum SideBarAppearance {
        struct Request {}
        struct Response {}
        struct ViewModel {
            let leadingOfHomeSidebar: CGFloat
        }
    }

    // MARK: - FocusUpdateCompleted
    enum FocusUpdateCompleted {
        struct Request {
            let currentWidthOfSceneTabsContainer: CGFloat
            let toSceneTab: Bool
        }
        struct Response {
            let widthOfSceneTabsContainer: CGFloat
        }
        struct ViewModel {
            let widthOfSceneTabsContainer: CGFloat
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

    // MARK: - UserSession
    enum UserSession {
        struct Request {}
        struct Response {}
        struct ViewModel {}
    }
}
