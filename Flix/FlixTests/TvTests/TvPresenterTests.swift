//
//  TvPresenterTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 16.11.2021.
//

import XCTest
@testable import Flix

final class TvPresenterTests: XCTestCase {

    // MARK: - Properties
    private var sut: TvPresenter!
    private var viewController: TvDisplayLogicSpy!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let presenter = TvPresenter()
        let viewController = TvDisplayLogicSpy()

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
    func testPresentTvCategories() {
        let response = TvModels.InitialData.Response(sections: [])
        sut.presentTvSections(response)

        XCTAssertTrue(viewController.isCalledDisplayTvSecitons, "Not started viewController display tv sections.")
    }

    func testPresentTvBroadcastsHeaderItem() {
        let items = [TvBroadcastItem(poster: nil, title: "", subtitle: "", description: "", tag: nil),
                     TvBroadcastItem(poster: nil, title: "", subtitle: "", description: "", tag: nil),
                     TvBroadcastItem(poster: nil, title: "", subtitle: "", description: "", tag: nil),
                     TvBroadcastItem(poster: nil, title: "", subtitle: "", description: "", tag: nil)]
        let header = TvBroadcastsSection.Header(tag: nil, stream: nil, categories: nil, title: nil)
        let broadcasts = TvBroadcastsSection(header: header, items: items)
        let tvSection = TvModels.Section.trendingLiveBroadcasts(broadcasts: broadcasts)

        let response = TvModels.TvItemData.Response(object: nil, indexPath: IndexPath(item: 0, section: 0), tvSection: tvSection)
        sut.presentTvBroadcastsHeaderItem(response)

        XCTAssertTrue(viewController.isCalledDisplayTvBroadcastsHeaderItem, "Not started viewController display TvBroadcastsHeaderItem.")
        XCTAssertFalse(viewController.isCalledDisplayTvBroadcastsItem, "Should not start viewController display TvBroadcastsItem.")
        XCTAssertFalse(viewController.isCalledDisplayTvChannelsHeaderItem, "Should not start viewController display TvChannelsHeaderItem.")
        XCTAssertFalse(viewController.isCalledDisplayTvChannelsItem, "Should not start viewController display TvChannelsItem.")
    }

    func testPresentTvBroadcastsItem() {
        let items = [TvBroadcastItem(poster: nil, title: "", subtitle: "", description: "", tag: nil),
                     TvBroadcastItem(poster: nil, title: "", subtitle: "", description: "", tag: nil),
                     TvBroadcastItem(poster: nil, title: "", subtitle: "", description: "", tag: nil),
                     TvBroadcastItem(poster: nil, title: "", subtitle: "", description: "", tag: nil)]
        let header = TvBroadcastsSection.Header(tag: nil, stream: nil, categories: nil, title: nil)
        let broadcasts = TvBroadcastsSection(header: header, items: items)
        let tvSection = TvModels.Section.trendingLiveBroadcasts(broadcasts: broadcasts)

        let response = TvModels.TvItemData.Response(object: nil, indexPath: IndexPath(item: items.count - 1, section: 0), tvSection: tvSection)
        sut.presentTvBroadcastsItem(response)

        XCTAssertFalse(viewController.isCalledDisplayTvBroadcastsHeaderItem, "Should not start viewController display TvBroadcastsHeaderItem.")
        XCTAssertTrue(viewController.isCalledDisplayTvBroadcastsItem, "Not started viewController display TvBroadcastsItem.")
        XCTAssertFalse(viewController.isCalledDisplayTvChannelsHeaderItem, "Should not start viewController display TvChannelsHeaderItem.")
        XCTAssertFalse(viewController.isCalledDisplayTvChannelsItem, "Should not start viewController display TvChannelsItem.")
    }

    func testPresentTvBroadcastsItemIndexOutOfRange() {
        let items = [TvBroadcastItem(poster: nil, title: "", subtitle: "", description: "", tag: nil),
                     TvBroadcastItem(poster: nil, title: "", subtitle: "", description: "", tag: nil),
                     TvBroadcastItem(poster: nil, title: "", subtitle: "", description: "", tag: nil),
                     TvBroadcastItem(poster: nil, title: "", subtitle: "", description: "", tag: nil)]
        let header = TvBroadcastsSection.Header(tag: nil, stream: nil, categories: nil, title: nil)
        let broadcasts = TvBroadcastsSection(header: header, items: items)
        let tvSection = TvModels.Section.trendingLiveBroadcasts(broadcasts: broadcasts)

        let response = TvModels.TvItemData.Response(object: nil, indexPath: IndexPath(item: items.count, section: 0), tvSection: tvSection)
        sut.presentTvBroadcastsItem(response)

        XCTAssertFalse(viewController.isCalledDisplayTvBroadcastsHeaderItem, "Should not start viewController display TvBroadcastsHeaderItem.")
        XCTAssertFalse(viewController.isCalledDisplayTvBroadcastsItem, "Should not start viewController display TvBroadcastsItem.")
        XCTAssertFalse(viewController.isCalledDisplayTvChannelsHeaderItem, "Should not start viewController display TvChannelsHeaderItem.")
        XCTAssertFalse(viewController.isCalledDisplayTvChannelsItem, "Should not start viewController display TvChannelsItem.")
    }


    func testPresentTvChannelsHeaderItem() {
        let items = [TvChannelItem(category: .crypto),
                     TvChannelItem(category: .crypto),
                     TvChannelItem(category: .crypto)]
        let channels = TvChannelsSection(categoryTitle: "", items: items)
        let tvSection = TvModels.Section.trendingChannels(channels: channels)

        let response = TvModels.TvItemData.Response(object: nil, indexPath: IndexPath(item: 0, section: 0), tvSection: tvSection)
        sut.presentTvChannelsHeaderItem(response)

        XCTAssertFalse(viewController.isCalledDisplayTvBroadcastsHeaderItem, "Should not start viewController display TvBroadcastsHeaderItem.")
        XCTAssertFalse(viewController.isCalledDisplayTvBroadcastsItem, "Should not start viewController display TvBroadcastsItem.")
        XCTAssertTrue(viewController.isCalledDisplayTvChannelsHeaderItem, "Not started viewController display TvChannelsHeaderItem.")
        XCTAssertFalse(viewController.isCalledDisplayTvChannelsItem, "Should not start viewController display TvChannelsItem.")
    }

    func testPresentTvChannelsItem() {
        let items = [TvChannelItem(category: .crypto),
                     TvChannelItem(category: .crypto),
                     TvChannelItem(category: .crypto)]
        let channels = TvChannelsSection(categoryTitle: "", items: items)
        let tvSection = TvModels.Section.trendingChannels(channels: channels)

        let response = TvModels.TvItemData.Response(object: nil, indexPath: IndexPath(item: items.count - 1, section: 0), tvSection: tvSection)
        sut.presentTvChannelsItem(response)

        XCTAssertFalse(viewController.isCalledDisplayTvBroadcastsHeaderItem, "Should not start viewController display TvBroadcastsHeaderItem.")
        XCTAssertFalse(viewController.isCalledDisplayTvBroadcastsItem, "Should not start viewController display TvBroadcastsItem.")
        XCTAssertFalse(viewController.isCalledDisplayTvChannelsHeaderItem, "Should not start viewController display TvChannelsHeaderItem.")
        XCTAssertTrue(viewController.isCalledDisplayTvChannelsItem, "Not started viewController display TvChannelsItem.")
    }

    func testPresentTvChannelsItemIndexOutOfRange() {
        let items = [TvChannelItem(category: .crypto),
                     TvChannelItem(category: .crypto),
                     TvChannelItem(category: .crypto)]
        let channels = TvChannelsSection(categoryTitle: "", items: items)
        let tvSection = TvModels.Section.trendingChannels(channels: channels)

        let response = TvModels.TvItemData.Response(object: nil, indexPath: IndexPath(item: items.count, section: 0), tvSection: tvSection)
        sut.presentTvChannelsItem(response)

        XCTAssertFalse(viewController.isCalledDisplayTvBroadcastsHeaderItem, "Should not start viewController display TvBroadcastsHeaderItem.")
        XCTAssertFalse(viewController.isCalledDisplayTvBroadcastsItem, "Should not start viewController display TvBroadcastsItem.")
        XCTAssertFalse(viewController.isCalledDisplayTvChannelsHeaderItem, "Should not start viewController display TvChannelsHeaderItem.")
        XCTAssertFalse(viewController.isCalledDisplayTvChannelsItem, "Should not start viewController display TvChannelsItem.")
    }

    func testPresentSelectedTvItem() {
        let response = TvModels.SelectTvItem.Response()
        sut.presentSelectedTvItem(response)

        XCTAssertTrue(viewController.isCalledDisplaySelectedTvItem, "Not started viewController display selected tv item.")
    }

    func testFocusChangedInMoviesCollectionToItemBeyoyndRightScreenEdgde() {
        let nextIndexPathItem = 6
        let tvBroadcasts = gettvBroadcasts(nextIndexPathItem: nextIndexPathItem)
        let tvSection = TvModels.Section.trendingLiveBroadcasts(broadcasts: tvBroadcasts)

        let response = TvModels.FocusChangedInTvCollection.Response(nextIndexPathItem: nextIndexPathItem, tvSection: tvSection)
        sut.focusChangedInTvCollection(response)

        XCTAssertFalse(viewController.isCalledNotifyHomeSceneToShowSidebar, "Should not start viewController NotifyHomeSceneToShowSidebar.")
        XCTAssertTrue(viewController.isCalledNotifyHomeSceneToHideSidebar, "Not started viewController NotifyHomeSceneToHideSidebar.")
        XCTAssertTrue(viewController.isCalledSetTvCollectionPosition, "Not started viewController SetTvCollectionPosition.")
    }

    func testFocusChangedInMoviesCollectionToTheFirstItem() {
        let nextIndexPathItem = 0
        let tvBroadcasts = gettvBroadcasts(nextIndexPathItem: nextIndexPathItem)
        let tvSection = TvModels.Section.trendingLiveBroadcasts(broadcasts: tvBroadcasts)

        let response = TvModels.FocusChangedInTvCollection.Response(nextIndexPathItem: nextIndexPathItem, tvSection: tvSection)
        sut.focusChangedInTvCollection(response)

        XCTAssertTrue(viewController.isCalledNotifyHomeSceneToShowSidebar, "Not started viewController NotifyHomeSceneToShowSidebar.")
        XCTAssertFalse(viewController.isCalledNotifyHomeSceneToHideSidebar, "Should not start viewController NotifyHomeSceneToHideSidebar.")
        XCTAssertTrue(viewController.isCalledSetTvCollectionPosition, "Not started viewController SetTvCollectionPosition.")
    }

    func testFocusChangedInMoviesCollection() {
        let nextIndexPathItem = 2
        let tvBroadcasts = gettvBroadcasts(nextIndexPathItem: nextIndexPathItem)
        let tvSection = TvModels.Section.trendingLiveBroadcasts(broadcasts: tvBroadcasts)

        let response = TvModels.FocusChangedInTvCollection.Response(nextIndexPathItem: nextIndexPathItem, tvSection: tvSection)
        sut.focusChangedInTvCollection(response)

        XCTAssertFalse(viewController.isCalledNotifyHomeSceneToShowSidebar, "Should not start viewController NotifyHomeSceneToShowSidebar.")
        XCTAssertFalse(viewController.isCalledNotifyHomeSceneToHideSidebar, "Should not start viewController NotifyHomeSceneToHideSidebar.")
        XCTAssertTrue(viewController.isCalledSetTvCollectionPosition, "Not started viewController SetTvCollectionPosition.")
    }
}

// MARK: - Private methods
private extension TvPresenterTests {
    func gettvBroadcasts(nextIndexPathItem: Int) -> TvBroadcastsSection {
        var section1 = [TvBroadcastItem]()
        let upperBorder = nextIndexPathItem + 5
        for i in 0...Int.random(in: nextIndexPathItem...upperBorder) {
            let item = TvBroadcastItem(poster: UIImage(named: "testTV\(Int.random(in: 1...3))"),
                                       title: "Broadcast \(i)",
                                       subtitle: "Subtitle broadcast \(i)\(i)",
                                       description: "asdfkjsdbnkjasns ksdn vjs,nd vjs dkv.sn v,s dnv,sm dnv .s dmv m,dsf v", tag: .live)
            section1.append(item)
        }
        let tvBroadcastsHeader = TvBroadcastsSection.Header(tag: "Featured stream",
                                                            stream: "Super duper stream.",
                                                            categories: "Technology | News",
                                                            title: "Trending Live Broadcasts")
        let tvBroadcasts = TvBroadcastsSection(header: tvBroadcastsHeader,
                                               items: section1)
        return tvBroadcasts
    }
}
