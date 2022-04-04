//
//  MoreEpisodesBusinessLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 17.11.2021.
//

import Foundation
@testable import Flix

final class MoreEpisodesBusinessLogicSpy {
    // MARK: - Properties
    private (set) var isCalledFetchContentInfo = false
    private (set) var isCalledFetchSeasons = false
    private (set) var isCalledFetchSeason = false
    private (set) var isCalledFetchSeries = false
    private (set) var isCalledFetchSeria = false
    private (set) var isCalledDidChangeFocusToSeason = false
}

extension MoreEpisodesBusinessLogicSpy: MoreEpisodesBusinessLogic {
    func fetchContentInfo(_ request: MoreEpisodesModels.InitialData.Request) {
        isCalledFetchContentInfo = true
    }
    
    func fetchSeasons(_ request: MoreEpisodesModels.SeasonsData.Request) {
        isCalledFetchSeasons = true
    }
    
    func fetchSeason(_ request: MoreEpisodesModels.SeasonData.Request) {
        isCalledFetchSeason = true
    }
    
    func fetchSeries(_ request: MoreEpisodesModels.SeriesData.Request) {
        isCalledFetchSeries = true
    }
    
    func fetchSeria(_ request: MoreEpisodesModels.SeriaData.Request) {
        isCalledFetchSeria = true
    }
    
    func didChangeFocusToSeason(_ request: MoreEpisodesModels.SeasonFocusChange.Request) {
        isCalledDidChangeFocusToSeason = true
    }
}
