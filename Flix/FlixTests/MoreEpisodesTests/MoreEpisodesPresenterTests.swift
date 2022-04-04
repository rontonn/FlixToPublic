//
//  MoreEpisodesPresenterTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 17.11.2021.
//

import XCTest
@testable import Flix

final class MoreEpisodesPresenterTests: XCTestCase {

    // MARK: - Properties
    private var sut: MoreEpisodesPresenter!
    private var viewController: MoreEpisodesDisplayLogicSpy!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let presenter = MoreEpisodesPresenter()
        let viewController = MoreEpisodesDisplayLogicSpy()

        presenter.viewController = viewController

        sut = presenter
        self.viewController = viewController
    }

    override func tearDown() {
        sut = nil
        viewController = nil

        super.tearDown()
    }

    // MARK: - Public Methods
    func testPresentContentInfo() {
        let response = MoreEpisodesModels.InitialData.Response(title: "", productionInfo: nil, genres: "")
        sut.presentContentInfo(response)

        XCTAssertTrue(viewController.isCalledShowContentInfo, "Not started view controller show content info")
    }

    func testPresentSeasons() {
        let seasonSection = SeasonSection(seasons: [])
        let response = MoreEpisodesModels.SeasonsData.Response(seasonSection: seasonSection)
        sut.presentSeasons(response)

        XCTAssertTrue(viewController.isCalledShowSeasons, "Not started view controller show seasons.")
    }

    func testPresentSeason() {
        let response = MoreEpisodesModels.SeasonData.Response(object: nil, season: .init(title: "", subtitle: ""))
        sut.presentSeason(response)

        XCTAssertTrue(viewController.isCalledShowSeason, "Not started view controller show season.")
    }

    func testPresentSeries() {
        let seriesSection = SeriesSection(series: [])
        let response = MoreEpisodesModels.SeriesData.Response(seriesSection: seriesSection)
        sut.presentSeries(response)

        XCTAssertTrue(viewController.isCalledShowSeries, "Not started view controller show series.")
    }

    func testPresentSeria() {
        let response = MoreEpisodesModels.SeriaData.Response(object: nil, seria: .init(posterImage: "",
                                                                                       seasonNumber: "",
                                                                                       seriaNumber: "",
                                                                                       duration: "",
                                                                                       seriaTitle: "",
                                                                                       description: "",
                                                                                       progress: 0))
        sut.presentSeria(response)

        XCTAssertTrue(viewController.isCalledShowSeria, "Not started view controller show seria.")
    }

    func testPresentSeriesInSelectedSeason() {
        let response = MoreEpisodesModels.SeasonFocusChange.Response(seriesIDs: [])
        sut.presentSeriesInSelectedSeason(response)

        XCTAssertTrue(viewController.isCalledShowSeriesInSelectedSeason, "Not started view controller show series in selected season.")
    }
}
