//
//  MoviesViewControllerTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 15.11.2021.
//

import XCTest
@testable import Flix

final class MoviesViewControllerTests: XCTestCase {

    // MARK: - Properties
    private var sut: MoviesViewController!
    private var interactor: MoviesBusinessLogicSpy!
    private var window: UIWindow!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let mainWindow = UIWindow()
        let viewController = AppScene.movies.viewController(MoviesViewController.self)
        let interactor = MoviesBusinessLogicSpy()

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

        XCTAssertTrue(interactor.isCalledFetchMovieCategories, "Not started interactor request FetchMovieCategories.")
    }
    
    func testFetchMovie() {
        let layout = MoviesCollectionLayoutSource(numberOfItemsInRow: 10).createLayout()
        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        let sectionUUIDs = randomUUIDs()
        snapshot.appendSections(sectionUUIDs)
        sectionUUIDs.forEach {
            let itemUUIDs = randomUUIDs()
            snapshot.appendItems(itemUUIDs, toSection: $0)
        }
        
        let viewModel = MoviesModels.InitialData.ViewModel(dataSourceSnapshot: snapshot, layout: layout, leadingPadding: 0)
        sut.displayMovieSecitons(viewModel)
        XCTAssertTrue(interactor.isCalledFetchMovie, "Not started interactor request FetchMovie.")
        XCTAssertTrue(interactor.isCalledFetchMovieSectionHeader, "Not started interactor request FetchMovieSectionHeader.")
    }

    func testFetchMovieWithZeroNumberOfItemsInRow() {
        let layout = MoviesCollectionLayoutSource(numberOfItemsInRow: 0).createLayout()
        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        let sectionUUIDs = randomUUIDs()
        snapshot.appendSections(sectionUUIDs)

        let viewModel = MoviesModels.InitialData.ViewModel(dataSourceSnapshot: snapshot, layout: layout, leadingPadding: 0)
        sut.displayMovieSecitons(viewModel)
        XCTAssertFalse(interactor.isCalledFetchMovie, "Should not start interactor request FetchMovie.")
        XCTAssertTrue(interactor.isCalledFetchMovieSectionHeader, "Not started interactor request FetchMovieSectionHeader.")
    }

    func testFetchMovieWithDefaultCollectionViewLayout() {
        let layout = UICollectionViewLayout()
        let snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()

        let viewModel = MoviesModels.InitialData.ViewModel(dataSourceSnapshot: snapshot, layout: layout, leadingPadding: 0)
        sut.displayMovieSecitons(viewModel)
        XCTAssertFalse(interactor.isCalledFetchMovie, "Should not start interactor request FetchMovie.")
        XCTAssertFalse(interactor.isCalledFetchMovieSectionHeader, "Should not start interactor request FetchMovieSectionHeader.")
    }

    func testDidSelectMovie() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        sut.collectionView(collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))

        XCTAssertTrue(interactor.isCalledDidSelectMovie, "Not started interactor request DidSelectMovie.")
    }
}
