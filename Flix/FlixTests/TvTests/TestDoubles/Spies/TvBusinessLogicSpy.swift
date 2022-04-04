//
//  TvBusinessLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 16.11.2021.
//

import Foundation
@testable import Flix

final class TvBusinessLogicSpy {
    // MARK: - Properties
    private (set) var isCalledFetchTvCategories = false
    private (set) var isCalledFetchTvBroadcastsHeaderItem = false
    private (set) var isCalledFetchTvBroadcastsItem = false
    private (set) var isCalledFetchTvChannelsHeaderItem = false
    private (set) var isCalledFetchTvChannelsItem = false
    private (set) var isCalledFocusChangedInTvCollection = false
    private (set) var isCalledDidSelectTvItem = false
}

extension TvBusinessLogicSpy: TvBusinessLogic {
    func fetchTvCategories(_ request: TvModels.InitialData.Request) {
        isCalledFetchTvCategories = true
    }

    func fetchTvBroadcastsHeaderItem(_ request: TvModels.TvItemData.Request) {
        isCalledFetchTvBroadcastsHeaderItem = true
    }

    func fetchTvBroadcastsItem(_ request: TvModels.TvItemData.Request) {
        isCalledFetchTvBroadcastsItem = true
    }

    func fetchTvChannelsHeaderItem(_ request: TvModels.TvItemData.Request) {
        isCalledFetchTvChannelsHeaderItem = true
    }

    func fetchTvChannelsItem(_ request: TvModels.TvItemData.Request) {
        isCalledFetchTvChannelsItem = true
    }

    func focusChangedInTvCollection(_ request: TvModels.FocusChangedInTvCollection.Request) {
        isCalledFocusChangedInTvCollection = true
    }

    func didSelectTvItem(_ request: TvModels.SelectTvItem.Request) {
        isCalledDidSelectTvItem = true
    }
}
