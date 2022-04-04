//
//  TvViewControllerTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 16.11.2021.
//

import XCTest
@testable import Flix

final class TvViewControllerTests: XCTestCase {

    // MARK: - Properties
    private var sut: TvViewController!
    private var interactor: TvBusinessLogicSpy!
    private var window: UIWindow!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let mainWindow = UIWindow()

        let viewController = AppScene.tv.viewController(TvViewController.self)
        let interactor = TvBusinessLogicSpy()

        viewController?.interactor = interactor

        sut = viewController
        window = mainWindow
        self.interactor = interactor

        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }

    override func tearDown() {
        sut = nil
        interactor = nil
        window = nil

        super.tearDown()
    }

    // MARK: - Public Methods
    func testViewDidLoad() {
        sut.viewDidLoad()

        XCTAssertTrue(interactor.isCalledFetchTvCategories, "Not started interactor request FetchTvCategories.")
    }

    func testFetchTvBroadcastsHeaderItem() {
        let tvSections = createTvSections()
        let layout = TvCollectionLayoutSource(sections: tvSections).createLayout()

        let snapshot = dataSourceSnapshotFor(tvSections)
        let viewModel = TvModels.InitialData.ViewModel(dataSourceSnapshot: snapshot, layout: layout, leadingPadding: 0)

        sut.displayTvSections(viewModel)

        XCTAssertTrue(interactor.isCalledFetchTvBroadcastsHeaderItem, "Not started interactor request FetchTvBroadcastsHeaderItem")
    }

    func testFetchTvBroadcastsItem() {
        let tvSections = createTvSections()
        let layout = TvCollectionLayoutSource(sections: tvSections).createLayout()

        let snapshot = dataSourceSnapshotFor(tvSections)
        let viewModel = TvModels.InitialData.ViewModel(dataSourceSnapshot: snapshot, layout: layout, leadingPadding: 0)

        sut.displayTvSections(viewModel)

        XCTAssertTrue(interactor.isCalledFetchTvBroadcastsItem, "Not started interactor request FetchTvBroadcastsItem")
    }

    func testFetchTvChannelsHeaderItem() {
        let tvSections = createTvSections()

        let layout = TvCollectionLayoutSource(sections: tvSections).createLayout()

        let snapshot = dataSourceSnapshotFor(tvSections)
        let viewModel = TvModels.InitialData.ViewModel(dataSourceSnapshot: snapshot, layout: layout, leadingPadding: 0)

        sut.displayTvSections(viewModel)

        XCTAssertTrue(interactor.isCalledFetchTvChannelsHeaderItem, "Not started interactor request FetchTvChannelsHeaderItem")
    }

    func testFetchTvChannelsItem() {
        let tvSections = createTvSections()
        let layout = TvCollectionLayoutSource(sections: tvSections).createLayout()

        let snapshot = dataSourceSnapshotFor(tvSections)
        let viewModel = TvModels.InitialData.ViewModel(dataSourceSnapshot: snapshot, layout: layout, leadingPadding: 0)

        sut.displayTvSections(viewModel)

        XCTAssertTrue(interactor.isCalledFetchTvChannelsItem, "Not started interactor request FetchTvChannelsItem")
    }

    func testFetchTvBroadcastsHeaderItemWithoutSections() {
        let layout = TvCollectionLayoutSource(sections: []).createLayout()
        let snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()

        let viewModel = TvModels.InitialData.ViewModel(dataSourceSnapshot: snapshot, layout: layout, leadingPadding: 0)

        sut.displayTvSections(viewModel)

        XCTAssertFalse(interactor.isCalledFetchTvBroadcastsHeaderItem, "Should not start interactor request FetchTvBroadcastsHeaderItem")
    }

    func testFetchTvBroadcastsItemWithoutSections() {
        let layout = TvCollectionLayoutSource(sections: []).createLayout()
        let snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()

        let viewModel = TvModels.InitialData.ViewModel(dataSourceSnapshot: snapshot, layout: layout, leadingPadding: 0)

        sut.displayTvSections(viewModel)

        XCTAssertFalse(interactor.isCalledFetchTvBroadcastsItem, "Should not start interactor request FetchTvBroadcastsItem")
    }

    func testFetchTvChannelsHeaderItemWithoutSections() {
        let layout = TvCollectionLayoutSource(sections: []).createLayout()
        let snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()

        let viewModel = TvModels.InitialData.ViewModel(dataSourceSnapshot: snapshot, layout: layout, leadingPadding: 0)

        sut.displayTvSections(viewModel)

        XCTAssertFalse(interactor.isCalledFetchTvChannelsHeaderItem, "Should not start interactor request FetchTvChannelsHeaderItem")
    }

    func testFetchTvChannelsItemWithoutSections() {
        let layout = TvCollectionLayoutSource(sections: []).createLayout()
        let snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()

        let viewModel = TvModels.InitialData.ViewModel(dataSourceSnapshot: snapshot, layout: layout, leadingPadding: 0)

        sut.displayTvSections(viewModel)

        XCTAssertFalse(interactor.isCalledFetchTvChannelsItem, "Should not start interactor request FetchTvChannelsItem")
    }

    func testFetchTvBroadcastsHeaderItemWithDefaultCollectionViewLayout() {
        let layout = UICollectionViewLayout()

        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        let sectionUUIDs = randomUUIDs()
        snapshot.appendSections(sectionUUIDs)
        sectionUUIDs.forEach {
            let itemUUIDs = randomUUIDs()
            snapshot.appendItems(itemUUIDs, toSection: $0)
        }

        let viewModel = TvModels.InitialData.ViewModel(dataSourceSnapshot: snapshot, layout: layout, leadingPadding: 0)

        sut.displayTvSections(viewModel)

        XCTAssertFalse(interactor.isCalledFetchTvBroadcastsHeaderItem, "Should not start interactor request FetchTvBroadcastsHeaderItem")
    }

    func testFetchTvBroadcastsItemWithDefaultCollectionViewLayout() {
        let layout = UICollectionViewLayout()

        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        let sectionUUIDs = randomUUIDs()
        snapshot.appendSections(sectionUUIDs)
        sectionUUIDs.forEach {
            let itemUUIDs = randomUUIDs()
            snapshot.appendItems(itemUUIDs, toSection: $0)
        }

        let viewModel = TvModels.InitialData.ViewModel(dataSourceSnapshot: snapshot, layout: layout, leadingPadding: 0)
        sut.displayTvSections(viewModel)

        XCTAssertFalse(interactor.isCalledFetchTvBroadcastsItem, "Should not start interactor request FetchTvBroadcastsItem")
    }

    func testFetchTvChannelsHeaderItemWithDefaultCollectionViewLayout() {
        let layout = UICollectionViewLayout()

        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        let sectionUUIDs = randomUUIDs()
        snapshot.appendSections(sectionUUIDs)
        sectionUUIDs.forEach {
            let itemUUIDs = randomUUIDs()
            snapshot.appendItems(itemUUIDs, toSection: $0)
        }

        let viewModel = TvModels.InitialData.ViewModel(dataSourceSnapshot: snapshot, layout: layout, leadingPadding: 0)
        sut.displayTvSections(viewModel)

        XCTAssertFalse(interactor.isCalledFetchTvChannelsHeaderItem, "Should not start interactor request FetchTvChannelsHeaderItem")
    }

    func testFetchTvChannelsItemWithDefaultCollectionViewLayout() {
        let layout = UICollectionViewLayout()

        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        let sectionUUIDs = randomUUIDs()
        snapshot.appendSections(sectionUUIDs)
        sectionUUIDs.forEach {
            let itemUUIDs = randomUUIDs()
            snapshot.appendItems(itemUUIDs, toSection: $0)
        }

        let viewModel = TvModels.InitialData.ViewModel(dataSourceSnapshot: snapshot, layout: layout, leadingPadding: 0)
        sut.displayTvSections(viewModel)

        XCTAssertFalse(interactor.isCalledFetchTvChannelsItem, "Should not start interactor request FetchTvChannelsItem")
    }

    func testDidSelectTvItem() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        sut.collectionView(collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))

        XCTAssertTrue(interactor.isCalledDidSelectTvItem, "Not started interactor request DidSelectTvItem.")
    }
}

// MARK: - Private methods
private extension TvViewControllerTests {
    func createTvSections() ->  [TvModels.Section] {
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

        let tvSections = [tvBroadcastsSection,
                          tvChannelsSection]
        return tvSections
    }

    func dataSourceSnapshotFor(_ tvSections: [TvModels.Section]) -> NSDiffableDataSourceSnapshot<UUID, UUID> {
        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        tvSections.forEach { tvSection in
            switch tvSection {
            case .trendingChannels(let channels):
                snapshot.appendSections([channels.id])
                let uuids: [UUID] = channels.items.map{ $0.id }
                snapshot.appendItems(uuids)
            case .trendingLiveBroadcasts(let broadcasts):
                snapshot.appendSections([broadcasts.id])
                let uuids: [UUID] = broadcasts.items.map{ $0.id }
                snapshot.appendItems(uuids)
            }
        }

        return snapshot
    }
}
