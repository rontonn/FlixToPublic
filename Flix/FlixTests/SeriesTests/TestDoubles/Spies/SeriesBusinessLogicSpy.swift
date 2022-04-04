//
//  SeriesBusinessLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 16.11.2021.
//

import Foundation
@testable import Flix

final class SeriesBusinessLogicSpy {
    // MARK: - Properties
    private (set) var isCalledFetchSeriesCategories = false
    private (set) var isCalledFetchSeries = false
    private (set) var isCalledFetchSeriesSectionHeader = false
    private (set) var isCalledFocusChangedInSeriesCollection = false
    private (set) var isCalledDidSelectSeries = false
}

extension SeriesBusinessLogicSpy: SeriesBusinessLogic {
    func fetchSeriesCategories(_ request: SeriesModels.InitialData.Request) {
        isCalledFetchSeriesCategories = true
    }

    func fetchSeries(_ request: SeriesModels.SeriesData.Request) {
        isCalledFetchSeries = true
    }

    func fetchSeriesSectionHeader(_ request: SeriesModels.SeriesData.Request) {
        isCalledFetchSeriesSectionHeader = true
    }
    
    func focusChangedInSeriesCollection(_ request: SeriesModels.FocusChangedInSeriesCollection.Request) {
        isCalledFocusChangedInSeriesCollection = true
    }
    
    func didSelectSeries(_ request: SeriesModels.SelectSeries.Request) {
        isCalledDidSelectSeries = true
    }
}
