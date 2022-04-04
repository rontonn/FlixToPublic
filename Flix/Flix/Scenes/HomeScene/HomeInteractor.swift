//
//  
//  HomeInteractor.swift
//  FlixAR
//
//  Created by Anton Romanov on 12.10.2021.
//
//

import UIKit

protocol HomeBusinessLogic {
    func provideSceneTabs(_ request: HomeModels.InitialData.Request)
    func fetchSceneTab(_ request: HomeModels.SceneTabData.Request)
    func showHomeSidebar(_ request: HomeModels.SideBarAppearance.Request)
    func hideHomeSideBar(_ request: HomeModels.SideBarAppearance.Request)
    func focusUpdateCompleted(_ request: HomeModels.FocusUpdateCompleted.Request)
    func didSelectHomeTab(_ request: HomeModels.SelectHomeTab.Request)
    func fetchUpdatedTabs(_ request: HomeModels.UpdatedData.Request)
    func onAuthorise(_ request: HomeModels.UserSession.Request)
    func onDisconnect(_ request: HomeModels.UserSession.Request)
}

protocol HomeDataStore {
    var sceneTabs: [SceneTab] { get }
}

final class HomeInteractor: HomeDataStore {
    // MARK: - Properties
    var presenter: HomePresentationLogic?
    var sceneTabs: [SceneTab] = []

    let collapsedWidthOfSceneTabsContainer: CGFloat = 98
    let expandedWidthOfSceneTabsContainer: CGFloat = 308
}

// MARK: - HomeBusinessLogic
extension HomeInteractor: HomeBusinessLogic {
    func provideSceneTabs(_ request: HomeModels.InitialData.Request) {
        setupSceneTabs()
        let response = HomeModels.InitialData.Response(sceneTabs: sceneTabs)
        presenter?.presentSceneTabs(response)
    }

    func fetchSceneTab(_ request: HomeModels.SceneTabData.Request) {
        guard let sceneTab = sceneTabs[safe: request.indexPath.item] else {
            return
        }
        let response = HomeModels.SceneTabData.Response(object: request.object, sceneTab: sceneTab)
        presenter?.presentSceneTab(response)
    }

    func showHomeSidebar(_ request: HomeModels.SideBarAppearance.Request) {
        let response = HomeModels.SideBarAppearance.Response()
        presenter?.showHomeSidebar(response)
    }

    func hideHomeSideBar(_ request: HomeModels.SideBarAppearance.Request) {
        let response = HomeModels.SideBarAppearance.Response()
        presenter?.hideHomeSideBar(response)
    }

    func focusUpdateCompleted(_ request: HomeModels.FocusUpdateCompleted.Request) {
        if request.toSceneTab {
            focusUpdateCompletedToSceneTab(request.currentWidthOfSceneTabsContainer)
        } else {
            focusUpdateCompletedToOtherItem(request.currentWidthOfSceneTabsContainer)
        }
    }

    func didSelectHomeTab(_ request: HomeModels.SelectHomeTab.Request) {
        guard let sceneTab = sceneTabs[safe: request.indexPath.item] else {
            return
        }
        let response = HomeModels.SelectHomeTab.Response(sceneTab: sceneTab)
        presenter?.presentSelectedHomeTab(response)
    }

    func fetchUpdatedTabs(_ request: HomeModels.UpdatedData.Request) {
        setupSceneTabs()
        let response = HomeModels.UpdatedData.Response()
        presenter?.presentUpdatedTabs(response)
    }

    func onAuthorise(_ request: HomeModels.UserSession.Request) {
        let response = HomeModels.UserSession.Response()
        presenter?.presentOnAuthorise(response)
    }

    func onDisconnect(_ request: HomeModels.UserSession.Request) {
        let response = HomeModels.UserSession.Response()
        presenter?.presentOnDisconnect(response)
    }
}

// MARK: - Private methods
private extension HomeInteractor {
    func setupSceneTabs() {
        let profileImage = AccountsWorker.shared.currentProfile?.profileImage
        sceneTabs = [SceneTab(option: .profile(image: profileImage)),
                     SceneTab(option: .series),
                     SceneTab(option: .movies),
                     SceneTab(option: .music),
                     SceneTab(option: .tv),]
    }

    func focusUpdateCompletedToSceneTab(_ currentWidthOfSceneTabsContainer: CGFloat) {
        guard currentWidthOfSceneTabsContainer != expandedWidthOfSceneTabsContainer else {
            return
        }
        let response = HomeModels.FocusUpdateCompleted.Response(widthOfSceneTabsContainer: expandedWidthOfSceneTabsContainer)
        presenter?.focusUpdateCompleted(response)
    }

    func focusUpdateCompletedToOtherItem(_ currentWidthOfSceneTabsContainer: CGFloat) {
        guard currentWidthOfSceneTabsContainer != collapsedWidthOfSceneTabsContainer else {
            return
        }
        let response = HomeModels.FocusUpdateCompleted.Response(widthOfSceneTabsContainer: collapsedWidthOfSceneTabsContainer)
        presenter?.focusUpdateCompleted(response)
    }
}
