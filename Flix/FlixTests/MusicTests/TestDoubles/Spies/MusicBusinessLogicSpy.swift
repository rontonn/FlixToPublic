//
//  MusicBusinessLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 16.11.2021.
//

import Foundation
@testable import Flix

final class MusicBusinessLogicSpy {
    // MARK: - Properties
    private (set) var isCalledFetchMusicCategories = false
    private (set) var isCalledFetchMusicItem = false
    private (set) var isCalledFetchMusicSectionHeader = false
    private (set) var isCalledFocusChangedInMusicCollection = false
    private (set) var isCalledDidSelectMusic = false
}

extension MusicBusinessLogicSpy: MusicBusinessLogic {
    func fetchMusicCategories(_ request: MusicModels.InitialData.Request) {
        isCalledFetchMusicCategories = true
    }

    func fetchMusicItem(_ request: MusicModels.MusicItemData.Request) {
        isCalledFetchMusicItem = true
    }

    func fetchMusicSectionHeader(_ request: MusicModels.MusicItemData.Request) {
        isCalledFetchMusicSectionHeader = true
    }

    func focusChangedInMusicCollection(_ request: MusicModels.FocusChangedInMusicCollection.Request) {
        isCalledFocusChangedInMusicCollection = true
    }

    func didSelectMusic(_ request: MusicModels.SelectMusic.Request) {
        isCalledDidSelectMusic = true
    }
}
