//
//  MusicDisplayLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 16.11.2021.
//

import Foundation
@testable import Flix

final class MusicDisplayLogicSpy {
    // MARK: - Properties
    private (set) var isCalledDisplayMusicSecitons = false
    private (set) var isCalledDisplayMusicItem = false
    private (set) var isCalledDisplayMusicSectionHeader = false
    private (set) var isCalledSetMusicCollectionPosition = false
    private (set) var isCalledDisplaySelectedMusic = false
    private (set) var isCalledNotifyHomeSceneToShowSidebar = false
    private (set) var isCalledNotifyHomeSceneToHideSidebar = false
}

extension MusicDisplayLogicSpy: MusicDisplayLogic {
    func displayMusicSections(_ viewModel: MusicModels.InitialData.ViewModel) {
        isCalledDisplayMusicSecitons = true
    }

    func displayMusicItem(_ viewModel: MusicModels.MusicItemData.ViewModel) {
        isCalledDisplayMusicItem = true
    }

    func displayMusicSectionHeader(_ viewModel: MusicModels.MusicItemData.ViewModel) {
        isCalledDisplayMusicSectionHeader = true
    }

    func setMusicCollectionPosition(_ viewModel: MusicModels.FocusChangedInMusicCollection.ViewModel) {
        isCalledSetMusicCollectionPosition = true
    }

    func notifyHomeSceneToShowSidebar(_ viewModel: MusicModels.FocusChangedInMusicCollection.ViewModel) {
        isCalledNotifyHomeSceneToShowSidebar = true
    }

    func notifyHomeSceneToHideSidebar(_ viewModel: MusicModels.FocusChangedInMusicCollection.ViewModel) {
        isCalledNotifyHomeSceneToHideSidebar = true
    }

    func displaySelectedMusic(_ viewModel: MusicModels.SelectMusic.ViewModel) {
        isCalledDisplaySelectedMusic = true
    }
}
