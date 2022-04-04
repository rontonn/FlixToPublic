//
//  
//  SeriesPresenter.swift
//  Flix
//
//  Created by Anton Romanov on 15.10.2021.
//
//

import UIKit

protocol SeriesPresentationLogic {
    func presentSections(_ response: SeriesModels.InitialData.Response)
    func presentSeries(_ response: SeriesModels.SeriesData.Response)
    func presentSeriesSectionHeader(_ response: SeriesModels.SeriesData.Response)
    func focusChangedInSeriesCollection(_ response: SeriesModels.FocusChangedInSeriesCollection.Response)
    func presentSelectedSeries(_ response: SeriesModels.SelectSeries.Response)
}

final class SeriesPresenter {
    // MARK: - Properties
    weak var viewController: SeriesDisplayLogic?

    private let numberOfItemsInRow: CGFloat = 4
    private let leadingPaddingOfSeriesCollectionByDefault: CGFloat = 200
    private let leadingPaddingOfSeriesCollectionExpanded: CGFloat = 50
}

extension SeriesPresenter: SeriesPresentationLogic {
    func presentSections(_ response: SeriesModels.InitialData.Response) {
        let seriesCollectionLayoutSource = SeriesCollectionLayoutSource(numberOfItemsInRow: numberOfItemsInRow)
        let layout = seriesCollectionLayoutSource.createLayout()

        let snapshot = dataSourceSnapshotFor(response.seriesSections)
        let viewModel = SeriesModels.InitialData.ViewModel(dataSourceSnapshot: snapshot,
                                                           layout: layout,
                                                           leadingPadding: leadingPaddingOfSeriesCollectionByDefault)
        viewController?.displaySeriesSecitons(viewModel)
    }

    func presentSeries(_ response: SeriesModels.SeriesData.Response) {
        let viewModel = SeriesModels.SeriesData.ViewModel(object: response.object, categoryTile: response.categoryTile, series: response.series)
        viewController?.displaySeries(viewModel)
    }

    func presentSeriesSectionHeader(_ response: SeriesModels.SeriesData.Response) {
        let viewModel = SeriesModels.SeriesData.ViewModel(object: response.object, categoryTile: response.categoryTile, series: response.series)
        viewController?.displaySeriesSectionHeader(viewModel)
    }

    func focusChangedInSeriesCollection(_ response: SeriesModels.FocusChangedInSeriesCollection.Response) {
        guard numberOfItemsInRow != 0 else {
            return
        }
        
        let afterNextPosition = response.nextIndexPathItem + 1
        let itemPosition = CGFloat(afterNextPosition)

        notifyHomeSceneAboutSideBarPositionIfNeededFor(itemPosition)
        setSeriesCollectionPositionIfNeededFor(itemPosition)
    }

    func presentSelectedSeries(_ response: SeriesModels.SelectSeries.Response) {
        let viewModel = SeriesModels.SelectSeries.ViewModel()
        viewController?.displaySelectedSeries(viewModel)
    }
}

// MARK: - Private methods {
private extension SeriesPresenter {
    func notifyHomeSceneAboutSideBarPositionIfNeededFor(_ itemPosition: CGFloat) {
        let viewModel = SeriesModels.FocusChangedInSeriesCollection.ViewModel(leadingPadding: nil)
        if itemPosition >= numberOfItemsInRow {
            viewController?.notifyHomeSceneToHideSidebar(viewModel)

        } else if itemPosition == 1 {
            viewController?.notifyHomeSceneToShowSidebar(viewModel)
        }
    }

    func setSeriesCollectionPositionIfNeededFor(_ itemPosition: CGFloat) {
        var leadingPadding: CGFloat?

        if itemPosition >= numberOfItemsInRow {
            leadingPadding = leadingPaddingOfSeriesCollectionExpanded

        } else if itemPosition == 1 {
            leadingPadding = leadingPaddingOfSeriesCollectionByDefault

        }
        let viewModel = SeriesModels.FocusChangedInSeriesCollection.ViewModel(leadingPadding: leadingPadding)
        viewController?.setSeriesCollectionPosition(viewModel)
    }

    func dataSourceSnapshotFor(_ seriesSections: [VideoOnDemandSection]) -> NSDiffableDataSourceSnapshot<UUID, UUID> {
        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        seriesSections.forEach {
            snapshot.appendSections([$0.id])
            let uuids: [UUID] = $0.items.map{ $0.id }
            snapshot.appendItems(uuids, toSection: $0.id)
        }
        return snapshot
    }
}
