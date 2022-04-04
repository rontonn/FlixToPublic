//
//  
//  MoreEpisodesPresenter.swift
//  Flix
//
//  Created by Anton Romanov on 25.10.2021.
//
//

import UIKit

protocol MoreEpisodesPresentationLogic {
    func presentContentInfo(_ response: MoreEpisodesModels.InitialData.Response)
    func presentSeasons(_ response: MoreEpisodesModels.SeasonsData.Response)
    func presentSeason(_ response: MoreEpisodesModels.SeasonData.Response)
    func presentSeries(_ response: MoreEpisodesModels.SeriesData.Response)
    func presentSeria(_ response: MoreEpisodesModels.SeriaData.Response)
    func presentSeriesInSelectedSeason(_ response: MoreEpisodesModels.SeasonFocusChange.Response)
}

final class MoreEpisodesPresenter {
    // MARK: - Properties
    weak var viewController: MoreEpisodesDisplayLogic?
}

extension MoreEpisodesPresenter: MoreEpisodesPresentationLogic {
    func presentContentInfo(_ response: MoreEpisodesModels.InitialData.Response) {
        let viewModel = MoreEpisodesModels.InitialData.ViewModel(title: response.title,
                                                                 productionInfo: response.productionInfo,
                                                                 genres: response.genres)
        viewController?.showContentInfo(viewModel)
    }

    func presentSeasons(_ response: MoreEpisodesModels.SeasonsData.Response) {
        let seasonsCollectionLayoutSource = MoreEpisodesSeasonsCollectionLayoutSource()
        let layout = seasonsCollectionLayoutSource.createLayout()

        let sectionUUID = response.seasonSection.id
        let seasonsUUIDs = response.seasonSection.seasons.map { $0.id }

        let snapshot = dataSourceSnapshotFor(sectionUUID, seasonsUUIDs)
        let viewModel = MoreEpisodesModels.SeasonsData.ViewModel(dataSourceSnapshot: snapshot, layout: layout)
        viewController?.showSeasons(viewModel)
    }

    func presentSeason(_ response: MoreEpisodesModels.SeasonData.Response) {
        let viewModel = MoreEpisodesModels.SeasonData.ViewModel(object: response.object, season: response.season)
        viewController?.showSeason(viewModel)
    }

    func presentSeries(_ response: MoreEpisodesModels.SeriesData.Response) {
        let seriesCollectionLayoutSource = MoreEpisodesSeriesCollectionLayoutSource()
        let layout = seriesCollectionLayoutSource.createLayout()

        let sectionUUID = response.seriesSection.id
        let seriesUUIDs = response.seriesSection.series.map { $0.id }

        let snapshot = dataSourceSnapshotFor(sectionUUID, seriesUUIDs)
        let viewModel = MoreEpisodesModels.SeriesData.ViewModel(dataSourceSnapshot: snapshot, layout: layout)
        viewController?.showSeries(viewModel)
    }

    func presentSeria(_ response: MoreEpisodesModels.SeriaData.Response) {
        let viewModel = MoreEpisodesModels.SeriaData.ViewModel(object: response.object, seria: response.seria)
        viewController?.showSeria(viewModel)
    }

    func presentSeriesInSelectedSeason(_ response: MoreEpisodesModels.SeasonFocusChange.Response) {
        let viewModel = MoreEpisodesModels.SeasonFocusChange.ViewModel(seriesIDs: response.seriesIDs)
        viewController?.showSeriesInSelectedSeason(viewModel)
    }
}

// MARK: - Private methods
private extension MoreEpisodesPresenter {
    func dataSourceSnapshotFor(_ sectionUUID: UUID, _ itemUUIDs: [UUID]) -> NSDiffableDataSourceSnapshot<UUID, UUID> {
        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        snapshot.appendSections([sectionUUID])
        snapshot.appendItems(itemUUIDs)
        return snapshot
    }
}
