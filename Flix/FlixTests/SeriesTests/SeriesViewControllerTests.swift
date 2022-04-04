//
//  SeriesViewControllerTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 16.11.2021.
//

import XCTest
@testable import Flix

final class SeriesViewControllerTests: XCTestCase {

    // MARK: - Properties
    private var sut: SeriesViewController!
    private var interactor: SeriesBusinessLogicSpy!
    private var window: UIWindow!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let mainWindow = UIWindow()

        let viewController = AppScene.series.viewController(SeriesViewController.self)
        let interactor = SeriesBusinessLogicSpy()

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

        XCTAssertTrue(interactor.isCalledFetchSeriesCategories, "Not started interactor request FetchSeriesCategories.")
    }

    func testFetchSeries() {
        let layout = MoviesCollectionLayoutSource(numberOfItemsInRow: 10).createLayout()

        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        let sectionUUIDs = randomUUIDs()
        snapshot.appendSections(sectionUUIDs)
        sectionUUIDs.forEach {
            let itemUUIDs = randomUUIDs()
            snapshot.appendItems(itemUUIDs, toSection: $0)
        }

        let viewModel = SeriesModels.InitialData.ViewModel(dataSourceSnapshot: snapshot, layout: layout, leadingPadding: 0)

        sut.displaySeriesSecitons(viewModel)
        XCTAssertTrue(interactor.isCalledFetchSeries, "Not started interactor request FetchSeries.")
        XCTAssertTrue(interactor.isCalledFetchSeriesSectionHeader, "Not started interactor request FetchSeriesSectionHeader.")
    }

    func testFetchSeriesWithZeroNumberOfItemsInRow() {
        let layout = MoviesCollectionLayoutSource(numberOfItemsInRow: 0).createLayout()

        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        let sectionUUIDs = randomUUIDs()
        snapshot.appendSections(sectionUUIDs)

        let viewModel = SeriesModels.InitialData.ViewModel(dataSourceSnapshot: snapshot, layout: layout, leadingPadding: 0)

        sut.displaySeriesSecitons(viewModel)
        XCTAssertFalse(interactor.isCalledFetchSeries, "Should not start interactor request FetchSeries.")
        XCTAssertTrue(interactor.isCalledFetchSeriesSectionHeader, "Not started interactor request FetchSeriesSectionHeader.")
    }

    func testFetchSeriesWithDefaultCollectionViewLayout() {
        let layout = UICollectionViewLayout()

        let snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        let viewModel = SeriesModels.InitialData.ViewModel(dataSourceSnapshot: snapshot, layout: layout, leadingPadding: 0)

        sut.displaySeriesSecitons(viewModel)
        XCTAssertFalse(interactor.isCalledFetchSeries, "Should not start interactor request FetchSeries.")
        XCTAssertFalse(interactor.isCalledFetchSeriesSectionHeader, "Should not start interactor request FetchSeriesSectionHeader.")
    }

    func testDidSelectSeries() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        sut.collectionView(collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))

        XCTAssertTrue(interactor.isCalledDidSelectSeries, "Not started interactor request DidSelectSeries.")
    }
}
