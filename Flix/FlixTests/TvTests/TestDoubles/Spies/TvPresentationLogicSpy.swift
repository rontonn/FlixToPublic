//
//  TvPresentationLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 16.11.2021.
//

import Foundation
@testable import Flix

final class TvPresentationLogicSpy {
    // MARK: - Properties
    private (set) var isCalledPresentTvSections = false
    private (set) var isCalledPresentTvBroadcastsHeaderItem = false
    private (set) var isCalledPresentTvBroadcastsItem = false
    private (set) var isCalledPresentTvChannelsHeaderItem = false
    private (set) var isCalledPresentTvChannelsItem = false
    private (set) var isCalledFocusChangedInTvCollection = false
    private (set) var isCalledPresentSelectedTvItem = false
}

extension TvPresentationLogicSpy: TvPresentationLogic {
    func presentTvSections(_ response: TvModels.InitialData.Response) {
        isCalledPresentTvSections = true
    }

    func presentTvBroadcastsHeaderItem(_ response: TvModels.TvItemData.Response) {
        isCalledPresentTvBroadcastsHeaderItem = true
    }
    
    func presentTvBroadcastsItem(_ response: TvModels.TvItemData.Response) {
        isCalledPresentTvBroadcastsItem = true
    }
    
    func presentTvChannelsHeaderItem(_ response: TvModels.TvItemData.Response) {
        isCalledPresentTvChannelsHeaderItem = true
    }
    
    func presentTvChannelsItem(_ response: TvModels.TvItemData.Response) {
        isCalledPresentTvChannelsItem = true
    }

    func focusChangedInTvCollection(_ response: TvModels.FocusChangedInTvCollection.Response) {
        isCalledFocusChangedInTvCollection = true
    }

    func presentSelectedTvItem(_ response: TvModels.SelectTvItem.Response) {
        isCalledPresentSelectedTvItem = true
    }
}
