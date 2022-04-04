//
//  HomeDisplayLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 15.11.2021.
//

import Foundation
@testable import Flix

final class HomeDisplayLogicSpy {
    // MARK: - Properties
    private (set) var isCalledDisplaySceneTabs = false
    private (set) var isCalledDisplaySceneTab = false
    private (set) var isCalledShowHomeSidebar = false
    private (set) var isCalledHideHomeSideBar = false
    private (set) var isCalledFocusUpdateCompleted = false
    private (set) var isCalledDisplaySelectedHomeTab = false
    private (set) var isCalledDisplayUpdatedTabs = false
    private (set) var isCalledDisplayOnAuthorise = false
    private (set) var isCalledDisplayOnDisconnect = false
}

extension HomeDisplayLogicSpy: HomeDisplayLogic {
    func displaySceneTabs(_ viewModel: HomeModels.InitialData.ViewModel) {
        isCalledDisplaySceneTabs = true
    }

    func displaySceneTab(_ viewModel: HomeModels.SceneTabData.ViewModel) {
        isCalledDisplaySceneTab = true
    }

    func showHomeSidebar(_ viewModel: HomeModels.SideBarAppearance.ViewModel) {
        isCalledShowHomeSidebar = true
    }

    func hideHomeSideBar(_ viewModel: HomeModels.SideBarAppearance.ViewModel) {
        isCalledHideHomeSideBar = true
    }

    func focusUpdateCompleted(_ viewModel: HomeModels.FocusUpdateCompleted.ViewModel) {
        isCalledFocusUpdateCompleted = true
    }

    func displaySelectedHomeTab(_ viewModel: HomeModels.SelectHomeTab.ViewModel) {
        isCalledDisplaySelectedHomeTab = true
    }

    func displayUpdatedTabs(_ viewModel: HomeModels.UpdatedData.ViewModel) {
        isCalledDisplayUpdatedTabs = true
    }

    func displayOnAuthorise(_ viewModel: HomeModels.UserSession.ViewModel) {
        isCalledDisplayOnAuthorise = true
    }

    func displayOnDisconnect(_ viewModel: HomeModels.UserSession.ViewModel) {
        isCalledDisplayOnDisconnect = true
    }
}
