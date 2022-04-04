//
//  SeriesPresenterTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 16.11.2021.
//

import XCTest
@testable import Flix

final class SeriesPresenterTests: XCTestCase {

    // MARK: - Properties
    private var sut: SeriesPresenter!
    private var viewController: SeriesDisplayLogicSpy!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let presenter = SeriesPresenter()
        let viewController = SeriesDisplayLogicSpy()

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
    func testPresentSerisCategories() {
        let response = SeriesModels.InitialData.Response(seriesSections: [])
        sut.presentSections(response)

        XCTAssertTrue(viewController.isCalledDisplaySeriesSecitons, "Not started viewController display series sections.")
    }

    func testPresentSeries() {
        let series = VideoOnDemandItem(poster: nil, title: "", ratingOwner: "", ratingValue: 0, tag: nil)
        let response = SeriesModels.SeriesData.Response(object: nil, categoryTile: nil, series: series)
        sut.presentSeries(response)

        XCTAssertTrue(viewController.isCalledDisplaySeries, "Not started viewController display series.")
    }

    func testPresentSeriesSectionHeader() {
        let response = SeriesModels.SeriesData.Response(object: nil, categoryTile: "", series: nil)
        sut.presentSeriesSectionHeader(response)

        XCTAssertTrue(viewController.isCalledDisplaySeriesSectionHeader, "Not started viewController display series section header.")
    }

    func testPresentSelectedSeris() {
        let response = SeriesModels.SelectSeries.Response()
        sut.presentSelectedSeries(response)

        XCTAssertTrue(viewController.isCalledDisplaySelectedSeries, "Not started viewController display selected series.")
    }

    func testFocusChangedInSeriesCollectionToItemBeyoyndRightScreenEdgde() {
        let response = SeriesModels.FocusChangedInSeriesCollection.Response(nextIndexPathItem: 6)
        sut.focusChangedInSeriesCollection(response)

        XCTAssertFalse(viewController.isCalledNotifyHomeSceneToShowSidebar, "Should not start viewController NotifyHomeSceneToShowSidebar.")
        XCTAssertTrue(viewController.isCalledNotifyHomeSceneToHideSidebar, "Not started viewController NotifyHomeSceneToHideSidebar.")
        XCTAssertTrue(viewController.isCalledSetSeriesCollectionPosition, "Not started viewController SetSeriesCollectionPosition.")
    }

    func testFocusChangedInSeriesCollectionToTheFirstItem() {
        let response = SeriesModels.FocusChangedInSeriesCollection.Response(nextIndexPathItem: 0)
        sut.focusChangedInSeriesCollection(response)

        XCTAssertTrue(viewController.isCalledNotifyHomeSceneToShowSidebar, "Not started viewController NotifyHomeSceneToShowSidebar.")
        XCTAssertFalse(viewController.isCalledNotifyHomeSceneToHideSidebar, "Should not start viewController NotifyHomeSceneToHideSidebar.")
        XCTAssertTrue(viewController.isCalledSetSeriesCollectionPosition, "Not started viewController SetSeriesCollectionPosition.")
    }

    func testFocusChangedInSeriesCollection() {
        let response = SeriesModels.FocusChangedInSeriesCollection.Response(nextIndexPathItem: 2)
        sut.focusChangedInSeriesCollection(response)

        XCTAssertFalse(viewController.isCalledNotifyHomeSceneToShowSidebar, "Should not start viewController NotifyHomeSceneToShowSidebar.")
        XCTAssertFalse(viewController.isCalledNotifyHomeSceneToHideSidebar, "Should not start viewController NotifyHomeSceneToHideSidebar.")
        XCTAssertTrue(viewController.isCalledSetSeriesCollectionPosition, "Not started viewController SetSeriesCollectionPosition.")
    }
}
