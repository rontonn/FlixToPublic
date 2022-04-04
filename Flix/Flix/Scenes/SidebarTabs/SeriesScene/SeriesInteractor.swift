//
//  
//  SeriesInteractor.swift
//  Flix
//
//  Created by Anton Romanov on 15.10.2021.
//
//

import UIKit

protocol SeriesBusinessLogic {
    func fetchSeriesCategories(_ request: SeriesModels.InitialData.Request)
    func fetchSeries(_ request: SeriesModels.SeriesData.Request)
    func fetchSeriesSectionHeader(_ request: SeriesModels.SeriesData.Request)
    func focusChangedInSeriesCollection(_ request: SeriesModels.FocusChangedInSeriesCollection.Request)
    func didSelectSeries(_ request: SeriesModels.SelectSeries.Request)
}

protocol SeriesDataStore {
    var selectedSeries: VideoOnDemandItem? { get }
    var seriesSections: [VideoOnDemandSection] { get }
}

final class SeriesInteractor: SeriesDataStore {
    // MARK: - Properties
    var presenter: SeriesPresentationLogic?
    var selectedSeries: VideoOnDemandItem?
    var seriesSections: [VideoOnDemandSection] = []
}

extension SeriesInteractor: SeriesBusinessLogic {
    func fetchSeriesCategories(_ request: SeriesModels.InitialData.Request) {
        var section1 = [VideoOnDemandItem]()
        var section2 = [VideoOnDemandItem]()
        var section3 = [VideoOnDemandItem]()
        var section4 = [VideoOnDemandItem]()
        
        for _ in 0...Int.random(in: 1...10) {
            let item = VideoOnDemandItem(poster: UIImage(named: "testPoster\(Int.random(in: 1...7))"),
                                         title: "item \(Int.random(in: 1...100))",
                                         ratingOwner: "Privi",
                                         ratingValue: Float.random(in: 0...5),
                                         tag: VideoOnDemandItem.Tag.staked)
            section1.append(item)
        }
        for _ in 0...Int.random(in: 1...10) {
            let item = VideoOnDemandItem(poster: UIImage(named: "testPoster\(Int.random(in: 1...7))"),
                                         title: "item \(Int.random(in: 1...100))",
                                         ratingOwner: "Privi",
                                         ratingValue: Float.random(in: 0...5),
                                         tag: VideoOnDemandItem.Tag.claimed)
            section2.append(item)
        }
        for _ in 0...Int.random(in: 1...10) {
            let item = VideoOnDemandItem(poster: UIImage(named: "testPoster\(Int.random(in: 1...7))"),
                                         title: "item \(Int.random(in: 1...100))",
                                         ratingOwner: "Privi",
                                         ratingValue: Float.random(in: 0...5),
                                         tag: nil)
            section3.append(item)
        }
        for _ in 0...Int.random(in: 1...10) {
            let item = VideoOnDemandItem(poster: UIImage(named: "testPoster\(Int.random(in: 1...7))"),
                                         title: "item \(Int.random(in: 1...100))",
                                         ratingOwner: "Privi",
                                         ratingValue: Float.random(in: 0...5),
                                         tag: VideoOnDemandItem.Tag.claimed)
            section4.append(item)
        }
        seriesSections = [VideoOnDemandSection(categoryTitle: "Section Series 1", items: section1, type: .series),
                          VideoOnDemandSection(categoryTitle: "Section Series 2", items: section2, type: .series),
                          VideoOnDemandSection(categoryTitle: "Section Series 3", items: section3, type: .series),
                          VideoOnDemandSection(categoryTitle: "Section Series 4", items: section4, type: .series)]
        let response = SeriesModels.InitialData.Response(seriesSections: seriesSections)

        presenter?.presentSections(response)
    }

    func fetchSeries(_ request: SeriesModels.SeriesData.Request) {
        guard let seriesSection = seriesSections[safe: request.indexPath.section],
              let series = seriesSection.items[safe: request.indexPath.item] else {
            return
        }
        let response = SeriesModels.SeriesData.Response(object: request.object, categoryTile: nil, series: series)
        presenter?.presentSeries(response)
    }

    func fetchSeriesSectionHeader(_ request: SeriesModels.SeriesData.Request) {
        guard let seriesSection = seriesSections[safe: request.indexPath.section] else {
            return
        }
        let response = SeriesModels.SeriesData.Response(object: request.object, categoryTile: seriesSection.categoryTitle, series: nil)
        presenter?.presentSeriesSectionHeader(response)
    }

    func focusChangedInSeriesCollection(_ request: SeriesModels.FocusChangedInSeriesCollection.Request) {
        let response = SeriesModels.FocusChangedInSeriesCollection.Response(nextIndexPathItem: request.nextIndexPath.item)
        presenter?.focusChangedInSeriesCollection(response)
    }

    func didSelectSeries(_ request: SeriesModels.SelectSeries.Request) {
        guard let seriesSection = seriesSections[safe: request.indexPath.section],
              let selectedSeries = seriesSection.items[safe: request.indexPath.item] else {
            return
        }
        self.selectedSeries = selectedSeries
        let response = SeriesModels.SelectSeries.Response()
        presenter?.presentSelectedSeries(response)
    }
}
