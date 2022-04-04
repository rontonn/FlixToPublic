//
//  TvDisplayLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 16.11.2021.
//

import Foundation
@testable import Flix

final class TvDisplayLogicSpy {
    // MARK: - Properties
    private (set) var isCalledDisplayTvSecitons = false
    private (set) var isCalledDisplayTvBroadcastsHeaderItem = false
    private (set) var isCalledDisplayTvBroadcastsItem = false
    private (set) var isCalledDisplayTvChannelsHeaderItem = false
    private (set) var isCalledDisplayTvChannelsItem = false
    private (set) var isCalledSetTvCollectionPosition = false
    private (set) var isCalledDisplaySelectedTvItem = false
    private (set) var isCalledNotifyHomeSceneToShowSidebar = false
    private (set) var isCalledNotifyHomeSceneToHideSidebar = false
}

extension TvDisplayLogicSpy: TvDisplayLogic {
    func displayTvSections(_ viewModel: TvModels.InitialData.ViewModel) {
        isCalledDisplayTvSecitons = true
    }

    func displayTvBroadcastsHeaderItem(_ viewModel: TvModels.TvItemData.ViewModel) {
        isCalledDisplayTvBroadcastsHeaderItem = true
    }

    func displayTvBroadcastsItem(_ viewModel: TvModels.TvItemData.ViewModel) {
        isCalledDisplayTvBroadcastsItem = true
    }

    func displayTvChannelsHeaderItem(_ viewModel: TvModels.TvItemData.ViewModel) {
        isCalledDisplayTvChannelsHeaderItem = true
    }

    func displayTvChannelsItem(_ viewModel: TvModels.TvItemData.ViewModel) {
        isCalledDisplayTvChannelsItem = true
    }

    func setTvCollectionPosition(_ viewModel: TvModels.FocusChangedInTvCollection.ViewModel) {
        isCalledSetTvCollectionPosition = true
    }

    func notifyHomeSceneToShowSidebar(_ viewModel: TvModels.FocusChangedInTvCollection.ViewModel) {
        isCalledNotifyHomeSceneToShowSidebar = true
    }

    func notifyHomeSceneToHideSidebar(_ viewModel: TvModels.FocusChangedInTvCollection.ViewModel) {
        isCalledNotifyHomeSceneToHideSidebar = true
    }

    func displaySelectedTvItem(_ viewModel: TvModels.SelectTvItem.ViewModel) {
        isCalledDisplaySelectedTvItem = true
    }
}
