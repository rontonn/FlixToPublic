//
//  HomeBusinessLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 15.11.2021.
//

import Foundation
@testable import Flix

final class HomeBusinessLogicSpy {
    // MARK: - Properties
    private (set) var isCalledProvideSceneTabs = false
    private (set) var isCalledFetchSceneTab = false
    private (set) var isCalledShowHomeSidebar = false
    private (set) var isCalledHideHomeSideBar = false
    private (set) var isCalledFocusUpdateCompleted = false
    private (set) var isCalledDidSelectHomeTab = false
    private (set) var isCalledFetchUpdatedTabs = false
    private (set) var isCalledOnAuthorise = false
    private (set) var isCalledOnDisconnect = false
}

extension HomeBusinessLogicSpy: HomeBusinessLogic {
    func provideSceneTabs(_ request: HomeModels.InitialData.Request) {
        isCalledProvideSceneTabs = true
    }

    func fetchSceneTab(_ request: HomeModels.SceneTabData.Request) {
        isCalledFetchSceneTab = true
    }

    func showHomeSidebar(_ request: HomeModels.SideBarAppearance.Request) {
        isCalledShowHomeSidebar = true
    }

    func hideHomeSideBar(_ request: HomeModels.SideBarAppearance.Request) {
        isCalledHideHomeSideBar = true
    }

    func focusUpdateCompleted(_ request: HomeModels.FocusUpdateCompleted.Request) {
        isCalledFocusUpdateCompleted = true
    }

    func didSelectHomeTab(_ request: HomeModels.SelectHomeTab.Request) {
        isCalledDidSelectHomeTab = true
    }

    func fetchUpdatedTabs(_ request: HomeModels.UpdatedData.Request) {
        isCalledFetchUpdatedTabs = true
    }

    func onAuthorise(_ request: HomeModels.UserSession.Request) {
        isCalledOnAuthorise = true
    }
    
    func onDisconnect(_ request: HomeModels.UserSession.Request) {
        isCalledOnDisconnect = true
    }
}
