//
//  MoreEpisodesInteractorTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 17.11.2021.
//

import XCTest
@testable import Flix

final class MoreEpisodesInteractorTests: XCTestCase {

    // MARK: - Properties
    private var sut: MoreEpisodesInteractor!
    private var presenter: MoreEpisodesPresentationLogicSpy!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let interactor = MoreEpisodesInteractor()
        let presenter = MoreEpisodesPresentationLogicSpy()

        interactor.presenter = presenter

        sut = interactor
        self.presenter = presenter
    }

    override func tearDown() {
        sut = nil
        presenter = nil

        super.tearDown()
    }

    // MARK: - Public Methods
    func testFetchContentInfo() {
        let request = MoreEpisodesModels.InitialData.Request()
        sut.fetchContentInfo(request)

        XCTAssertTrue(presenter.isCalledPresentContentInfo, "Not started present content info.")
    }

    func testFetchSeasons() {
        let request = MoreEpisodesModels.SeasonsData.Request()
        sut.fetchSeasons(request)

        XCTAssertTrue(presenter.isCalledPresentSeasons, "Not started present seasons.")
    }

    func testFetchSeason() {
        sut.seasons = [Season(title: "Season 1", subtitle: "Just the beginning..."),
                       Season(title: "Season 2", subtitle: "Joly Yoly.")]

        let request = MoreEpisodesModels.SeasonData.Request(object: nil, indexPath: IndexPath(item: 0, section: 0))
        sut.fetchSeason(request)

        XCTAssertTrue(presenter.isCalledPresentSeason, "Not started present season.")
    }

    func testFetchSeasonWithEmptySeasons() {
        let request = MoreEpisodesModels.SeasonData.Request(object: nil, indexPath: IndexPath(item: 0, section: 0))
        sut.fetchSeason(request)

        XCTAssertFalse(presenter.isCalledPresentSeason, "Should not start present season.")
    }

    func testFetchSeries() {
        let request = MoreEpisodesModels.SeriesData.Request()
        sut.fetchSeries(request)

        XCTAssertTrue(presenter.isCalledPresentSeries, "Not started present series.")
    }

    func testFetchSeria() {
        sut.seasons = [Season(title: "Season 1", subtitle: "Just the beginning..."),
                       Season(title: "Season 2", subtitle: "Joly Yoly.")]
        sut.seasons.forEach {
            let series = [Seria(posterImage: "", seasonNumber: $0.title, seriaNumber: " Seria 1", duration: "30 min", seriaTitle: "Sun rises", description: "asdnkjsdfbngkflascjkvxncvaslfmcalksvmj asdkncak js,ncv klfdvn lksd vns,m nv,ds v", progress: 34),
                          Seria(posterImage: "", seasonNumber: $0.title, seriaNumber: " Seria 2", duration: "47 min", seriaTitle: "Sun is down.", description: "kjhkjhkjhjkh", progress: 62)]
            sut.seriesBySeason[$0.id] = series
        }
        sut.currentSeasonID = sut.seasons.first?.id

        let request = MoreEpisodesModels.SeriaData.Request(object: nil, indexPath: IndexPath(item: 1, section: 0))
        sut.fetchSeria(request)

        XCTAssertTrue(presenter.isCalledPresentSeria, "Not started present seria.")
    }

    func testFetchSeriaWithEmptySeries() {
        let request = MoreEpisodesModels.SeriaData.Request(object: nil, indexPath: IndexPath(item: 1, section: 0))
        sut.fetchSeria(request)

        XCTAssertFalse(presenter.isCalledPresentSeria, "Should not start present seria.")
    }

    func testFetchSeriaWithEmptySeasons() {
        sut.seasons.forEach {
            let series = [Seria(posterImage: "", seasonNumber: $0.title, seriaNumber: " Seria 1", duration: "30 min", seriaTitle: "Sun rises", description: "asdnkjsdfbngkflascjkvxncvaslfmcalksvmj asdkncak js,ncv klfdvn lksd vns,m nv,ds v", progress: 34),
                          Seria(posterImage: "", seasonNumber: $0.title, seriaNumber: " Seria 2", duration: "47 min", seriaTitle: "Sun is down.", description: "kjhkjhkjhjkh", progress: 62)]
            sut.seriesBySeason[$0.id] = series
        }

        let request = MoreEpisodesModels.SeriaData.Request(object: nil, indexPath: IndexPath(item: 1, section: 0))
        sut.fetchSeria(request)

        XCTAssertFalse(presenter.isCalledPresentSeria, "Should not start present seria.")
    }

    func testFetchSeriaWithoutCurrentSeasonID() {
        sut.seasons = [Season(title: "Season 1", subtitle: "Just the beginning..."),
                       Season(title: "Season 2", subtitle: "Joly Yoly.")]
        sut.seasons.forEach {
            let series = [Seria(posterImage: "", seasonNumber: $0.title, seriaNumber: " Seria 1", duration: "30 min", seriaTitle: "Sun rises", description: "asdnkjsdfbngkflascjkvxncvaslfmcalksvmj asdkncak js,ncv klfdvn lksd vns,m nv,ds v", progress: 34),
                          Seria(posterImage: "", seasonNumber: $0.title, seriaNumber: " Seria 2", duration: "47 min", seriaTitle: "Sun is down.", description: "kjhkjhkjhjkh", progress: 62)]
            sut.seriesBySeason[$0.id] = series
        }

        let request = MoreEpisodesModels.SeriaData.Request(object: nil, indexPath: IndexPath(item: 1, section: 0))
        sut.fetchSeria(request)

        XCTAssertFalse(presenter.isCalledPresentSeria, "Should not start present seria.")
    }

    func testDidChangeFocusToSeason() {
        sut.seasons = [Season(title: "Season 1", subtitle: "Just the beginning..."),
                       Season(title: "Season 2", subtitle: "Joly Yoly.")]
        sut.currentSeasonID = sut.seasons.first?.id

        sut.seasons.forEach {
            let series = [Seria(posterImage: "", seasonNumber: $0.title, seriaNumber: " Seria 1", duration: "30 min", seriaTitle: "Sun rises", description: "asdnkjsdfbngkflascjkvxncvaslfmcalksvmj asdkncak js,ncv klfdvn lksd vns,m nv,ds v", progress: 34),
                          Seria(posterImage: "", seasonNumber: $0.title, seriaNumber: " Seria 2", duration: "47 min", seriaTitle: "Sun is down.", description: "kjhkjhkjhjkh", progress: 62)]
            sut.seriesBySeason[$0.id] = series
        }

        let numberOfSeasons = sut.seasons.count
        let request = MoreEpisodesModels.SeasonFocusChange.Request(indexPath: IndexPath(item: numberOfSeasons - 1, section: 0))
        sut.didChangeFocusToSeason(request)

        XCTAssertTrue(presenter.isCalledPresentSeriesInSelectedSeason, "Not started present series in selected season.")
    }

    func testDidChangeFocusToSeasonWithEmptySeasons() {
        let request = MoreEpisodesModels.SeasonFocusChange.Request(indexPath: IndexPath(item: 2, section: 0))
        sut.didChangeFocusToSeason(request)

        XCTAssertFalse(presenter.isCalledPresentSeriesInSelectedSeason, "Should not start present series in selected season.")
    }

    func testDidChangeFocusToSeasonWithEmptySeries() {
        sut.seasons = [Season(title: "Season 1", subtitle: "Just the beginning..."),
                       Season(title: "Season 2", subtitle: "Joly Yoly.")]
        sut.currentSeasonID = sut.seasons.first?.id

        let request = MoreEpisodesModels.SeasonFocusChange.Request(indexPath: IndexPath(item: 2, section: 0))
        sut.didChangeFocusToSeason(request)

        XCTAssertFalse(presenter.isCalledPresentSeriesInSelectedSeason, "Should not start present series in selected season.")
    }
}
