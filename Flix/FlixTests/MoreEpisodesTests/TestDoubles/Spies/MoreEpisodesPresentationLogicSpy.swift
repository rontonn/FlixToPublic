//
//  MoreEpisodesPresentationLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 17.11.2021.
//

import Foundation
@testable import Flix

final class MoreEpisodesPresentationLogicSpy {
    // MARK: - Properties
    private (set) var isCalledPresentContentInfo = false
    private (set) var isCalledPresentSeasons = false
    private (set) var isCalledPresentSeason = false
    private (set) var isCalledPresentSeries = false
    private (set) var isCalledPresentSeria = false
    private (set) var isCalledPresentSeriesInSelectedSeason = false
}

extension MoreEpisodesPresentationLogicSpy: MoreEpisodesPresentationLogic {
    func presentContentInfo(_ response: MoreEpisodesModels.InitialData.Response) {
        isCalledPresentContentInfo = true
    }
    
    func presentSeasons(_ response: MoreEpisodesModels.SeasonsData.Response) {
        isCalledPresentSeasons = true
    }
    
    func presentSeason(_ response: MoreEpisodesModels.SeasonData.Response) {
        isCalledPresentSeason = true
    }
    
    func presentSeries(_ response: MoreEpisodesModels.SeriesData.Response) {
        isCalledPresentSeries = true
    }
    
    func presentSeria(_ response: MoreEpisodesModels.SeriaData.Response) {
        isCalledPresentSeria = true
    }
    
    func presentSeriesInSelectedSeason(_ response: MoreEpisodesModels.SeasonFocusChange.Response) {
        isCalledPresentSeriesInSelectedSeason = true
    }
}
