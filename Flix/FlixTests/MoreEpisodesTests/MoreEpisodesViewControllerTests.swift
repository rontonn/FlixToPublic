//
//  MoreEpisodesViewControllerTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 17.11.2021.
//

import XCTest
@testable import Flix

final class MoreEpisodesViewControllerTests: XCTestCase {

    // MARK: - Properties
    private var sut: MoreEpisodesViewController!
    private var interactor: MoreEpisodesBusinessLogicSpy!
    private var window: UIWindow!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let mainWindow = UIWindow()

        let viewController = AppScene.moreEpisodes.viewController(MoreEpisodesViewController.self)
        let interactor = MoreEpisodesBusinessLogicSpy()

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

        XCTAssertTrue(interactor.isCalledFetchContentInfo, "Not started interactor request FetchContentInfo.")
        XCTAssertTrue(interactor.isCalledFetchSeasons, "Not started interactor request FetchSeasons.")
        XCTAssertTrue(interactor.isCalledFetchSeries, "Not started interactor request FetchSeries.")
    }

    func testFetchSeason() {
        let layout = MoreEpisodesSeasonsCollectionLayoutSource().createLayout()

        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        let sectionUUID = UUID()
        let seasonsUUIDs = randomUUIDs()
        snapshot.appendSections([sectionUUID])
        snapshot.appendItems(seasonsUUIDs)

        let viewModel = MoreEpisodesModels.SeasonsData.ViewModel(dataSourceSnapshot: snapshot, layout: layout)
        sut.showSeasons(viewModel)

        XCTAssertTrue(interactor.isCalledFetchSeason, "Not started interactor request FetchSeason.")
    }

    func testFetchSeasonWithDefaultCollectionViewLayout() {
        let layout = UICollectionViewLayout()

        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        let sectionUUID = UUID()
        let seasonsUUIDs = randomUUIDs()
        snapshot.appendSections([sectionUUID])
        snapshot.appendItems(seasonsUUIDs)

        let viewModel = MoreEpisodesModels.SeasonsData.ViewModel(dataSourceSnapshot: snapshot, layout: layout)
        sut.showSeasons(viewModel)

        XCTAssertFalse(interactor.isCalledFetchSeason, "Should not start interactor request FetchSeason.")
    }

    func testFetchSeriaWithEmptySeasons() {
        let layout = UICollectionViewLayout()

        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        let sectionUUID = UUID()
        snapshot.appendSections([sectionUUID])

        let viewModel = MoreEpisodesModels.SeasonsData.ViewModel(dataSourceSnapshot: snapshot, layout: layout)
        sut.showSeasons(viewModel)

        XCTAssertFalse(interactor.isCalledFetchSeason, "Should not start interactor request FetchSeason.")
    }

    func testFetchSeria() {
        let layout = MoreEpisodesSeriesCollectionLayoutSource().createLayout()

        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        let sectionUUID = UUID()
        let seriesUUIDs = randomUUIDs()
        snapshot.appendSections([sectionUUID])
        snapshot.appendItems(seriesUUIDs)

        let viewModel = MoreEpisodesModels.SeriesData.ViewModel(dataSourceSnapshot: snapshot, layout: layout)
        sut.showSeries(viewModel)

        XCTAssertTrue(interactor.isCalledFetchSeria, "Not started interactor request FetchSeria.")
    }

    func testFetchSeriaWithDefaultCollectionViewLayout() {
        let layout = UICollectionViewLayout()

        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        let sectionUUID = UUID()
        let seriesUUIDs = randomUUIDs()
        snapshot.appendSections([sectionUUID])
        snapshot.appendItems(seriesUUIDs)

        let viewModel = MoreEpisodesModels.SeriesData.ViewModel(dataSourceSnapshot: snapshot, layout: layout)

        sut.showSeries(viewModel)

        XCTAssertFalse(interactor.isCalledFetchSeria, "Should not start interactor request FetchSeria.")
    }

    func testFetchSeriaWithEmptySeries() {
        let layout = UICollectionViewLayout()

        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        let sectionUUID = UUID()
        snapshot.appendSections([sectionUUID])

        let viewModel = MoreEpisodesModels.SeriesData.ViewModel(dataSourceSnapshot: snapshot, layout: layout)
        sut.showSeries(viewModel)

        XCTAssertFalse(interactor.isCalledFetchSeria, "Should not start interactor request FetchSeria.")
    }
}
