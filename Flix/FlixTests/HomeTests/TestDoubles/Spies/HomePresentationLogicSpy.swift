//
//  HomePresentationLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 15.11.2021.
//

import Foundation
@testable import Flix

final class HomePresentationLogicSpy {
    // MARK: - Properties
    private (set) var isCalledPresentSceneTabs = false
    private (set) var isCalledPresentSceneTab = false
    private (set) var isCalledShowHomeSidebar = false
    private (set) var isCalledHideHomeSideBar = false
    private (set) var isCalledFocusUpdateCompleted = false
    private (set) var isCalledPresentSelectedHomeTab = false
    private (set) var isCalledPresentUpdatedTabs = false
    private (set) var isCalledPresentOnAuthorise = false
    private (set) var isCalledPresentOnDisconnect = false
}

extension HomePresentationLogicSpy: HomePresentationLogic {
    func presentSceneTabs(_ response: HomeModels.InitialData.Response) {
        isCalledPresentSceneTabs = true
    }

    func presentSceneTab(_ response: HomeModels.SceneTabData.Response) {
        isCalledPresentSceneTab = true
    }

    func showHomeSidebar(_ response: HomeModels.SideBarAppearance.Response) {
        isCalledShowHomeSidebar = true
    }

    func hideHomeSideBar(_ response: HomeModels.SideBarAppearance.Response) {
        isCalledHideHomeSideBar = true
    }

    func focusUpdateCompleted(_ response: HomeModels.FocusUpdateCompleted.Response) {
        isCalledFocusUpdateCompleted = true
    }

    func presentSelectedHomeTab(_ response: HomeModels.SelectHomeTab.Response) {
        isCalledPresentSelectedHomeTab = true
    }

    func presentUpdatedTabs(_ response: HomeModels.UpdatedData.Response) {
        isCalledPresentUpdatedTabs = true
    }

    func presentOnAuthorise(_ response: HomeModels.UserSession.Response) {
        isCalledPresentOnAuthorise = true
    }

    func presentOnDisconnect(_ response: HomeModels.UserSession.Response) {
        isCalledPresentOnDisconnect = true
    }
}
