//
//  
//  HomePresenter.swift
//  FlixAR
//
//  Created by Anton Romanov on 12.10.2021.
//
//

import UIKit

protocol HomePresentationLogic {
    func presentSceneTabs(_ response: HomeModels.InitialData.Response)
    func presentSceneTab(_ response: HomeModels.SceneTabData.Response)
    func showHomeSidebar(_ response: HomeModels.SideBarAppearance.Response)
    func hideHomeSideBar(_ response: HomeModels.SideBarAppearance.Response)
    func focusUpdateCompleted(_ response: HomeModels.FocusUpdateCompleted.Response)
    func presentSelectedHomeTab(_ response: HomeModels.SelectHomeTab.Response)
    func presentUpdatedTabs(_ response: HomeModels.UpdatedData.Response)
    func presentOnAuthorise(_ response: HomeModels.UserSession.Response)
    func presentOnDisconnect(_ response: HomeModels.UserSession.Response)
}

final class HomePresenter {
    // MARK: - Properties
    weak var viewController: HomeDisplayLogic?

    private let sceneTabsSectionUUID = UUID()
}

// MARK: - HomePresentationLogic
extension HomePresenter: HomePresentationLogic {
    func presentSceneTabs(_ response: HomeModels.InitialData.Response) {
        let homeSceneTabsCollectionLayoutSource = HomeSceneTabsCollectionLayoutSource()
        let layout = homeSceneTabsCollectionLayoutSource.createLayout()

        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        snapshot.appendSections([sceneTabsSectionUUID])
        let uuids = response.sceneTabs.map { $0.id }
        snapshot.appendItems(uuids)
        let viewModel = HomeModels.InitialData.ViewModel(dataSourceSnapshot: snapshot,
                                                         layout: layout)
        viewController?.displaySceneTabs(viewModel)
    }

    func presentSceneTab(_ response: HomeModels.SceneTabData.Response) {
        let viewModel = HomeModels.SceneTabData.ViewModel(object: response.object, sceneTab: response.sceneTab)
        viewController?.displaySceneTab(viewModel)
    }

    func showHomeSidebar(_ response: HomeModels.SideBarAppearance.Response) {
        let viewModel = HomeModels.SideBarAppearance.ViewModel(leadingOfHomeSidebar: 50)
        viewController?.showHomeSidebar(viewModel)
    }

    func hideHomeSideBar(_ response: HomeModels.SideBarAppearance.Response) {
        let viewModel = HomeModels.SideBarAppearance.ViewModel(leadingOfHomeSidebar: -400)
        viewController?.hideHomeSideBar(viewModel)
    }

    func focusUpdateCompleted(_ response: HomeModels.FocusUpdateCompleted.Response) {
        let viewModel = HomeModels.FocusUpdateCompleted.ViewModel(widthOfSceneTabsContainer: response.widthOfSceneTabsContainer)
        viewController?.focusUpdateCompleted(viewModel)
    }

    func presentSelectedHomeTab(_ response: HomeModels.SelectHomeTab.Response) {
        let viewModel = HomeModels.SelectHomeTab.ViewModel(sceneTab: response.sceneTab)
        viewController?.displaySelectedHomeTab(viewModel)
    }

    func presentUpdatedTabs(_ response: HomeModels.UpdatedData.Response) {
        let viewModel = HomeModels.UpdatedData.ViewModel(section: sceneTabsSectionUUID)
        viewController?.displayUpdatedTabs(viewModel)
    }

    func presentOnAuthorise(_ response: HomeModels.UserSession.Response) {
        let viewModel = HomeModels.UserSession.ViewModel()
        viewController?.displayOnAuthorise(viewModel)
    }

    func presentOnDisconnect(_ response: HomeModels.UserSession.Response) {
        let viewModel = HomeModels.UserSession.ViewModel()
        viewController?.displayOnDisconnect(viewModel)
    }
}
