//
//  MusicPresentationLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 16.11.2021.
//

import Foundation
@testable import Flix

final class MusicPresentationLogicSpy {
    // MARK: - Properties
    private (set) var isCalledPresentSections = false
    private (set) var isCalledPresentMusicItem = false
    private (set) var isCalledPresentMusicSectionHeader = false
    private (set) var isCalledFocusChangedInMusicCollection = false
    private (set) var isCalledPresentSelectedMusic = false
}

extension MusicPresentationLogicSpy: MusicPresentationLogic {
    func presentMusicSections(_ response: MusicModels.InitialData.Response) {
        isCalledPresentSections = true
    }

    func presentMusicItem(_ response: MusicModels.MusicItemData.Response) {
        isCalledPresentMusicItem = true
    }

    func presentMusicSectionHeader(_ response: MusicModels.MusicItemData.Response) {
        isCalledPresentMusicSectionHeader = true
    }

    func focusChangedInMusicCollection(_ response: MusicModels.FocusChangedInMusicCollection.Response) {
        isCalledFocusChangedInMusicCollection = true
    }

    func presentSelectedMusic(_ response: MusicModels.SelectMusic.Response) {
        isCalledPresentSelectedMusic = true
    }
}
