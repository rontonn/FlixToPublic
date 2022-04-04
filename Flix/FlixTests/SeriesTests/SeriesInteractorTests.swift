//
//  SeriesInteractorTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 16.11.2021.
//

import XCTest
@testable import Flix

final class SeriesInteractorTests: XCTestCase {

    // MARK: - Properties
    private var sut: SeriesInteractor!
    private var presenter: SeriesPresentationLogicSpy!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let interactor = SeriesInteractor()
        let presenter = SeriesPresentationLogicSpy()

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
    func testFetchSeriesCategories() {
        let request = SeriesModels.InitialData.Request()
        sut.fetchSeriesCategories(request)

        XCTAssertTrue(presenter.isCalledPresentSections, "Not started present series sections.")
    }

    func testFetchSeries() {
        sut.seriesSections = createSeriesSections()

        let firstSection = 0
        let numberOfItems = sut.seriesSections[firstSection].items.count
        let request = SeriesModels.SeriesData.Request(object: nil, indexPath: IndexPath(item: numberOfItems - 1, section: firstSection))
        sut.fetchSeries(request)

        XCTAssertTrue(presenter.isCalledPresentSeries, "Not started present series.")
    }

    func testFetchSeriesSectionHeader() {
        sut.seriesSections = createSeriesSections()

        let firstSection = 0
        let numberOfItems = sut.seriesSections[firstSection].items.count
        let request = SeriesModels.SeriesData.Request(object: nil, indexPath: IndexPath(item: numberOfItems - 1, section: firstSection))
        sut.fetchSeriesSectionHeader(request)

        XCTAssertTrue(presenter.isCalledPresentSeriesSectionHeader, "Not started present series section header.")
    }

    func testFetchSeriesWithoutSeriesSections() {
        let request = SeriesModels.SeriesData.Request(object: nil, indexPath: IndexPath(item: 0, section: 0))
        sut.fetchSeries(request)

        XCTAssertFalse(presenter.isCalledPresentSeries, "Not started present series.")
    }

    func testFetchSeriesSectionHeaderWithoutSeriesSections() {
        let request = SeriesModels.SeriesData.Request(object: nil, indexPath: IndexPath(item: 0, section: 0))
        sut.fetchSeriesSectionHeader(request)

        XCTAssertFalse(presenter.isCalledPresentSeriesSectionHeader, "Not started present series section header.")
    }

    func testFocusChangedInSeriesCollection() {
        let request = SeriesModels.FocusChangedInSeriesCollection.Request(nextIndexPath: IndexPath(item: 0, section: 0))
        sut.focusChangedInSeriesCollection(request)

        XCTAssertTrue(presenter.isCalledFocusChangedInSeriesCollection, "Not started present FocusChangedInSeriesCollection.")
    }

    func testDidSelectSeries() {
        var selectedSeriesTitle = ""
        var selectedSeriesID: UUID?

        var section1 = [VideoOnDemandItem]()
        var section2 = [VideoOnDemandItem]()
        var section3 = [VideoOnDemandItem]()
        var section4 = [VideoOnDemandItem]()

        for _ in 0...Int.random(in: 1...10) {
            let item = VideoOnDemandItem(poster: nil,
                                         title: "item \(Int.random(in: 1...100))",
                                         ratingOwner: "",
                                         ratingValue: 0,
                                         tag: nil)
            section1.append(item)
        }
        for i in 0...Int.random(in: 1...10) {
            let item = VideoOnDemandItem(poster: nil,
                                         title: "item \(Int.random(in: 1...100))",
                                         ratingOwner: "",
                                         ratingValue: 0,
                                         tag: nil)
            if i == 1 {
                selectedSeriesID = item.id
                selectedSeriesTitle = item.title
            }
            section2.append(item)
        }
        for _ in 0...Int.random(in: 1...10) {
            let item = VideoOnDemandItem(poster: nil,
                                         title: "item \(Int.random(in: 1...100))",
                                         ratingOwner: "",
                                         ratingValue: 0,
                                         tag: nil)
            section3.append(item)
        }
        for _ in 0...Int.random(in: 1...10) {
            let item = VideoOnDemandItem(poster: nil,
                                         title: "item \(Int.random(in: 1...100))",
                                         ratingOwner: "",
                                         ratingValue: 0,
                                         tag: nil)
            section4.append(item)
        }
        sut.seriesSections = [VideoOnDemandSection(categoryTitle: "", items: section1, type: .series),
                              VideoOnDemandSection(categoryTitle: "", items: section2, type: .series),
                              VideoOnDemandSection(categoryTitle: "", items: section3, type: .series),
                              VideoOnDemandSection(categoryTitle: "", items: section4, type: .series)]

        let request = SeriesModels.SelectSeries.Request(indexPath: IndexPath(item: 1, section: 1))
        sut.didSelectSeries(request)

        XCTAssertEqual(sut.selectedSeries?.title, selectedSeriesTitle)
        XCTAssertEqual(sut.selectedSeries?.id, selectedSeriesID)
        XCTAssertTrue(presenter.isCalledPresentSelectedSeries, "Not started present selected series.")
    }

    func testDidSelectSeriesFailed() {
        let request = SeriesModels.SelectSeries.Request(indexPath: IndexPath(item: 1, section: 1))
        sut.didSelectSeries(request)

        XCTAssertFalse(presenter.isCalledPresentSelectedSeries, "Should not start present selected series.")
    }
}

// MARK: - Private methods
private extension SeriesInteractorTests {
    func createSeriesSections() -> [VideoOnDemandSection] {
        var section1 = [VideoOnDemandItem]()
        var section2 = [VideoOnDemandItem]()
        var section3 = [VideoOnDemandItem]()
        var section4 = [VideoOnDemandItem]()

        for _ in 0...Int.random(in: 1...10) {
            let item = VideoOnDemandItem(poster: nil,
                                         title: "item \(Int.random(in: 1...100))",
                                         ratingOwner: "",
                                         ratingValue: 0,
                                         tag: nil)
            section1.append(item)
        }
        for _ in 0...Int.random(in: 1...10) {
            let item = VideoOnDemandItem(poster: nil,
                                         title: "item \(Int.random(in: 1...100))",
                                         ratingOwner: "",
                                         ratingValue: 0,
                                         tag: nil)
            section2.append(item)
        }
        for _ in 0...Int.random(in: 1...10) {
            let item = VideoOnDemandItem(poster: nil,
                                         title: "item \(Int.random(in: 1...100))",
                                         ratingOwner: "",
                                         ratingValue: 0,
                                         tag: nil)
            section3.append(item)
        }
        for _ in 0...Int.random(in: 1...10) {
            let item = VideoOnDemandItem(poster: nil,
                                         title: "item \(Int.random(in: 1...100))",
                                         ratingOwner: "",
                                         ratingValue: 0,
                                         tag: nil)
            section4.append(item)
        }
        let seriesSections = [VideoOnDemandSection(categoryTitle: "", items: section1, type: .series),
                              VideoOnDemandSection(categoryTitle: "", items: section2, type: .series),
                              VideoOnDemandSection(categoryTitle: "", items: section3, type: .series),
                              VideoOnDemandSection(categoryTitle: "", items: section4, type: .series)]
        return seriesSections
    }
}
