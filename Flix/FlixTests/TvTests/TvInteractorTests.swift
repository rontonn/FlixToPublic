//
//  TvInteractorTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 16.11.2021.
//

import XCTest
@testable import Flix

final class TvInteractorTests: XCTestCase {

    // MARK: - Properties
    private var sut: TvInteractor!
    private var presenter: TvPresentationLogicSpy!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let interactor = TvInteractor()
        let presenter = TvPresentationLogicSpy()

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
    func testFetchTvCategories() {
        let request = TvModels.InitialData.Request()
        sut.fetchTvCategories(request)

        XCTAssertTrue(presenter.isCalledPresentTvSections, "Not started present tv sections.")
    }

    func testFetchTvBroadcastsHeaderItem() {
        createTvSections()

        let numberOfItems = sut.tvSections.count
        let request = TvModels.TvItemData.Request(object: nil, indexPath: IndexPath(item: 0, section: numberOfItems - 1))

        sut.fetchTvBroadcastsHeaderItem(request)
        XCTAssertTrue(presenter.isCalledPresentTvBroadcastsHeaderItem, "Not started present TvBroadcastsHeaderItem.")
    }

    func testFetchTvBroadcastsItem() {
        createTvSections()

        let numberOfItems = sut.tvSections.count
        let request = TvModels.TvItemData.Request(object: nil, indexPath: IndexPath(item: 0, section: numberOfItems - 1))

        sut.fetchTvBroadcastsItem(request)
        XCTAssertTrue(presenter.isCalledPresentTvBroadcastsItem, "Not started present TvBroadcastsItem.")
    }

    func testFetchTvChannelsHeaderItem() {
        createTvSections()

        let numberOfItems = sut.tvSections.count
        let request = TvModels.TvItemData.Request(object: nil, indexPath: IndexPath(item: 0, section: numberOfItems - 1))

        sut.fetchTvChannelsHeaderItem(request)
        XCTAssertTrue(presenter.isCalledPresentTvChannelsHeaderItem, "Not started present TvChannelsHeaderItem.")
    }

    func testFetchTvChannelsItem() {
        createTvSections()

        let numberOfItems = sut.tvSections.count
        let request = TvModels.TvItemData.Request(object: nil, indexPath: IndexPath(item: 0, section: numberOfItems - 1))

        sut.fetchTvChannelsItem(request)
        XCTAssertTrue(presenter.isCalledPresentTvChannelsItem, "Not started present TvChannelsItem.")
    }

    func testFetchTvBroadcastsHeaderItemWithoutTvSections() {
        let request = TvModels.TvItemData.Request(object: nil, indexPath: IndexPath(item: 0, section: 0))

        sut.fetchTvBroadcastsHeaderItem(request)
        XCTAssertFalse(presenter.isCalledPresentTvBroadcastsHeaderItem, "Should not start present TvBroadcastsHeaderItem.")
    }

    func testFetchTvBroadcastsItemWithoutTvSections() {
        let request = TvModels.TvItemData.Request(object: nil, indexPath: IndexPath(item: 0, section: 0))

        sut.fetchTvBroadcastsItem(request)
        XCTAssertFalse(presenter.isCalledPresentTvBroadcastsItem, "Should not start present TvBroadcastsItem.")
    }

    func testFetchTvChannelsHeaderItemWithoutTvSections() {
        let request = TvModels.TvItemData.Request(object: nil, indexPath: IndexPath(item: 0, section: 0))

        sut.fetchTvChannelsHeaderItem(request)
        XCTAssertFalse(presenter.isCalledPresentTvChannelsHeaderItem, "Should not start present TvChannelsHeaderItem.")
    }

    func testFetchTvChannelsItemWithoutTvSections() {
        let request = TvModels.TvItemData.Request(object: nil, indexPath: IndexPath(item: 0, section: 0))

        sut.fetchTvChannelsItem(request)
        XCTAssertFalse(presenter.isCalledPresentTvChannelsItem, "Should not start present TvChannelsItem.")
    }

    func testFocusChangedInTvCollection() {
        createTvSections()
    
        let request = TvModels.FocusChangedInTvCollection.Request(nextIndexPath: IndexPath(item: 0, section: 0))
        sut.focusChangedInTvCollection(request)

        XCTAssertTrue(presenter.isCalledFocusChangedInTvCollection, "Not started present FocusChangedInTvCollection.")
    }

    func testFocusChangedInTvCollectionWithoutTvSections() {
        let request = TvModels.FocusChangedInTvCollection.Request(nextIndexPath: IndexPath(item: 0, section: 0))
        sut.focusChangedInTvCollection(request)

        XCTAssertFalse(presenter.isCalledFocusChangedInTvCollection, "Should not start present FocusChangedInTvCollection.")
    }

    func testDidSelectSeries() {
        var selectedTvBroadcastTitle: String?
        var selectedTvChannelCategory: TvChannelItem.Category?
        var selectedTvBroadcastID: UUID?
        var selectedTvChannelID: UUID?

        var section1 = [TvBroadcastItem]()
        let section2 = [TvChannelItem(category: .flixLive),
                        TvChannelItem(category: .crypto),
                        TvChannelItem(category: .crypto)]
        
        for i in 0...Int.random(in: 2...10) {
            let item = TvBroadcastItem(poster: nil,
                                       title: "",
                                       subtitle: "",
                                       description: "",
                                       tag: nil)
            if i == 2 {
                selectedTvBroadcastTitle = item.title
                selectedTvBroadcastID = item.id
            }
            section1.append(item)
        }

        let tvBroadcastsHeader = TvBroadcastsSection.Header(tag: "",
                                                            stream: "",
                                                            categories: "",
                                                            title: "Trending Live Broadcasts")
        let tvBroadcasts = TvBroadcastsSection(header: tvBroadcastsHeader,
                                                      items: section1)
        let tvChannels = TvChannelsSection(categoryTitle: "Trending Channels", items: section2)

        let tvBroadcastsSection = TvModels.Section.trendingLiveBroadcasts(broadcasts: tvBroadcasts)
        let tvChannelsSection = TvModels.Section.trendingChannels(channels: tvChannels)

        sut.tvSections = [tvBroadcastsSection,
                          tvChannelsSection]

        let request = TvModels.SelectTvItem.Request(indexPath: IndexPath(item: 2, section: 0))
        sut.didSelectTvItem(request)

        XCTAssertEqual(sut.selectedTvBroadcastItem?.title, selectedTvBroadcastTitle)
        XCTAssertEqual(sut.selectedTvBroadcastItem?.id, selectedTvBroadcastID)

        let request2 = TvModels.SelectTvItem.Request(indexPath: IndexPath(item: 1, section: 1))
        selectedTvChannelCategory = section2[1].category
        selectedTvChannelID = section2[1].id
        sut.didSelectTvItem(request2)

        XCTAssertEqual(sut.selectedTvChannelItem?.category, selectedTvChannelCategory)
        XCTAssertEqual(sut.selectedTvChannelItem?.id, selectedTvChannelID)

        XCTAssertTrue(presenter.isCalledPresentSelectedTvItem, "Not started present selected tv item.")
    }

    func testDidSelectTvFailed() {
        let request = TvModels.SelectTvItem.Request(indexPath: IndexPath(item: 1, section: 1))
        sut.didSelectTvItem(request)

        XCTAssertFalse(presenter.isCalledPresentSelectedTvItem, "Should not start present selected tv item.")
    }
}

// MARK: - Private methods
private extension TvInteractorTests {
    func createTvSections() {
        var section1 = [TvBroadcastItem]()
        let section2 = [TvChannelItem(category: .flixLive),
                        TvChannelItem(category: .crypto),
                        TvChannelItem(category: .crypto)]
        
        for _ in 0...Int.random(in: 2...10) {
            let item = TvBroadcastItem(poster: nil,
                                       title: "",
                                       subtitle: "",
                                       description: "",
                                       tag: nil)
            section1.append(item)
        }

        let tvBroadcastsHeader = TvBroadcastsSection.Header(tag: "",
                                                            stream: "",
                                                            categories: "",
                                                            title: "Trending Live Broadcasts")
        let tvBroadcasts = TvBroadcastsSection(header: tvBroadcastsHeader,
                                                      items: section1)
        let tvChannels = TvChannelsSection(categoryTitle: "Trending Channels", items: section2)

        let tvBroadcastsSection = TvModels.Section.trendingLiveBroadcasts(broadcasts: tvBroadcasts)
        let tvChannelsSection = TvModels.Section.trendingChannels(channels: tvChannels)

        sut.tvSections = [tvBroadcastsSection,
                          tvChannelsSection]
    }
}
