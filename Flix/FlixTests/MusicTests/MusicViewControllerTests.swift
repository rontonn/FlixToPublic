//
//  MusicViewControllerTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 16.11.2021.
//

import XCTest
@testable import Flix

final class MusicViewControllerTests: XCTestCase {

    // MARK: - Properties
    private var sut: MusicViewController!
    private var interactor: MusicBusinessLogicSpy!
    private var window: UIWindow!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let mainWindow = UIWindow()

        let viewController = AppScene.music.viewController(MusicViewController.self)
        let interactor = MusicBusinessLogicSpy()

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

        XCTAssertTrue(interactor.isCalledFetchMusicCategories, "Not started interactor request FetchMusicCategories.")
    }

    func testFetchMusicItem() {
        let layout = MusicCollectionLayoutSource(numberOfItemsInRow: 10).createLayout()

        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        let sectionUUIDs = randomUUIDs()
        snapshot.appendSections(sectionUUIDs)
        sectionUUIDs.forEach {
            let itemUUIDs = randomUUIDs()
            snapshot.appendItems(itemUUIDs, toSection: $0)
        }

        let viewModel = MusicModels.InitialData.ViewModel(dataSourceSnapshot: snapshot, layout: layout, leadingPadding: 0)

        sut.displayMusicSections(viewModel)
        XCTAssertTrue(interactor.isCalledFetchMusicItem, "Not started interactor request FetchMusicItem.")
        XCTAssertTrue(interactor.isCalledFetchMusicSectionHeader, "Should not start interactor request FetchMusicSectionHeader.")
    }

    func testFetchMovieWithZeroNumberOfItemsInRow() {
        let layout = MusicCollectionLayoutSource(numberOfItemsInRow: 0).createLayout()

        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        let sectionUUIDs = randomUUIDs()
        snapshot.appendSections(sectionUUIDs)

        let viewModel = MusicModels.InitialData.ViewModel(dataSourceSnapshot: snapshot, layout: layout, leadingPadding: 0)

        sut.displayMusicSections(viewModel)
        XCTAssertFalse(interactor.isCalledFetchMusicItem, "Should not start interactor request FetchMusicItem.")
        XCTAssertTrue(interactor.isCalledFetchMusicSectionHeader, "Not started interactor request FetchMusicSectionHeader.")
    }

    func testFetchMovieWithDefaultCollectionViewLayout() {
        let layout = UICollectionViewLayout()

        let snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()

        let viewModel = MusicModels.InitialData.ViewModel(dataSourceSnapshot: snapshot, layout: layout, leadingPadding: 0)

        sut.displayMusicSections(viewModel)
        XCTAssertFalse(interactor.isCalledFetchMusicItem, "Should not start interactor request FetchMusicItem.")
        XCTAssertFalse(interactor.isCalledFetchMusicSectionHeader, "Should not start interactor request FetchMusicSectionHeader.")
    }

    func testDidSelectMusic() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        sut.collectionView(collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))

        XCTAssertTrue(interactor.isCalledDidSelectMusic, "Not started interactor request DidSelectMusic.")
    }
}
