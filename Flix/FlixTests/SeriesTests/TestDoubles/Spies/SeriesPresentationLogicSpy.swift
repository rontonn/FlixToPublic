//
//  SeriesPresentationLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 16.11.2021.
//

import Foundation
@testable import Flix

final class SeriesPresentationLogicSpy {
    // MARK: - Properties
    private (set) var isCalledPresentSections = false
    private (set) var isCalledPresentSeries = false
    private (set) var isCalledPresentSeriesSectionHeader = false
    private (set) var isCalledFocusChangedInSeriesCollection = false
    private (set) var isCalledPresentSelectedSeries = false
}

extension SeriesPresentationLogicSpy: SeriesPresentationLogic {
    func presentSections(_ response: SeriesModels.InitialData.Response) {
        isCalledPresentSections = true
    }

    func presentSeries(_ response: SeriesModels.SeriesData.Response) {
        isCalledPresentSeries = true
    }

    func presentSeriesSectionHeader(_ response: SeriesModels.SeriesData.Response) {
        isCalledPresentSeriesSectionHeader = true
    }
    
    func focusChangedInSeriesCollection(_ response: SeriesModels.FocusChangedInSeriesCollection.Response) {
        isCalledFocusChangedInSeriesCollection = true
    }
    
    func presentSelectedSeries(_ response: SeriesModels.SelectSeries.Response) {
        isCalledPresentSelectedSeries = true
    }
}
