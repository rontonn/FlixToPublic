//
//  MoreEpisodesDisplayLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 17.11.2021.
//

import Foundation
@testable import Flix

final class MoreEpisodesDisplayLogicSpy {
    // MARK: - Properties
    private (set) var isCalledShowContentInfo = false
    private (set) var isCalledShowSeasons = false
    private (set) var isCalledShowSeason = false
    private (set) var isCalledShowSeries = false
    private (set) var isCalledShowSeria = false
    private (set) var isCalledShowSeriesInSelectedSeason = false
}

extension MoreEpisodesDisplayLogicSpy: MoreEpisodesDisplayLogic {
    func showContentInfo(_ viewModel: MoreEpisodesModels.InitialData.ViewModel) {
        isCalledShowContentInfo = true
    }
    
    func showSeasons(_ viewModel: MoreEpisodesModels.SeasonsData.ViewModel) {
        isCalledShowSeasons = true
    }
    
    func showSeason(_ viewModel: MoreEpisodesModels.SeasonData.ViewModel) {
        isCalledShowSeason = true
    }
    
    func showSeries(_ viewModel: MoreEpisodesModels.SeriesData.ViewModel) {
        isCalledShowSeries = true
    }
    
    func showSeria(_ viewModel: MoreEpisodesModels.SeriaData.ViewModel) {
        isCalledShowSeria = true
    }
    
    func showSeriesInSelectedSeason(_ viewModel: MoreEpisodesModels.SeasonFocusChange.ViewModel) {
        isCalledShowSeriesInSelectedSeason = true
    }
}
