//
//  SeriesDisplayLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 16.11.2021.
//

import Foundation
@testable import Flix

final class SeriesDisplayLogicSpy {
    // MARK: - Properties
    private (set) var isCalledDisplaySeriesSecitons = false
    private (set) var isCalledDisplaySeries = false
    private (set) var isCalledDisplaySeriesSectionHeader = false
    private (set) var isCalledSetSeriesCollectionPosition = false
    private (set) var isCalledDisplaySelectedSeries = false
    private (set) var isCalledNotifyHomeSceneToShowSidebar = false
    private (set) var isCalledNotifyHomeSceneToHideSidebar = false
}

extension SeriesDisplayLogicSpy: SeriesDisplayLogic {
    func displaySeriesSecitons(_ viewModel: SeriesModels.InitialData.ViewModel) {
        isCalledDisplaySeriesSecitons = true
    }

    func displaySeries(_ viewModel: SeriesModels.SeriesData.ViewModel) {
        isCalledDisplaySeries = true
    }

    func displaySeriesSectionHeader(_ viewModel: SeriesModels.SeriesData.ViewModel) {
        isCalledDisplaySeriesSectionHeader = true
    }

    func setSeriesCollectionPosition(_ viewModel: SeriesModels.FocusChangedInSeriesCollection.ViewModel) {
        isCalledSetSeriesCollectionPosition = true
    }

    func notifyHomeSceneToShowSidebar(_ viewModel: SeriesModels.FocusChangedInSeriesCollection.ViewModel) {
        isCalledNotifyHomeSceneToShowSidebar = true
    }

    func notifyHomeSceneToHideSidebar(_ viewModel: SeriesModels.FocusChangedInSeriesCollection.ViewModel) {
        isCalledNotifyHomeSceneToHideSidebar = true
    }

    func displaySelectedSeries(_ viewModel: SeriesModels.SelectSeries.ViewModel) {
        isCalledDisplaySelectedSeries = true
    }
}
