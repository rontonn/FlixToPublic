//
//  ErrorViewControllerTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 19.11.2021.
//

import XCTest
@testable import Flix

final class ErrorViewControllerTests: XCTestCase {

    // MARK: - Properties
    private var sut: ErrorViewController!
    private var interactor: ErrorBusinessLogicSpy!
    private var window: UIWindow!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let mainWindow = UIWindow()

        let viewController = AppScene.error.viewController(ErrorViewController.self)
        let interactor = ErrorBusinessLogicSpy()

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

        XCTAssertTrue(interactor.isCalledFetchErrorInfo, "Not started interactor request FetchErrorInfo.")
    }

    func testFetchErrorActionData() {
        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        snapshot.appendSections([UUID()])
        let itemUUIDs = randomUUIDs()
        snapshot.appendItems(itemUUIDs)

        let layout = ErrorCollectionLayoutSource().createLayout()
        let viewModel = ErrorModels.InitialData.ViewModel(description: nil,
                                                          image: nil,
                                                          dataSourceSnapshot: snapshot, layout: layout)
        sut.displayError(viewModel)
        XCTAssertTrue(interactor.isCalledFetchErrorActionData, "Not started interactor request FetchErrorActionData.")
    }

    func testFetchErrorActionDataWithZeroNumberOfItemsInRow() {
        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        snapshot.appendSections([UUID()])

        let layout = ErrorCollectionLayoutSource().createLayout()
        let viewModel = ErrorModels.InitialData.ViewModel(description: nil,
                                                          image: nil,
                                                          dataSourceSnapshot: snapshot, layout: layout)
        sut.displayError(viewModel)
        XCTAssertFalse(interactor.isCalledFetchErrorActionData, "Should not start interactor request FetchErrorActionData.")
    }

    func testFetchErrorActionDataWithDefaultCollectionViewLayout() {
        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        snapshot.appendSections([UUID()])
        let itemUUIDs = randomUUIDs()
        snapshot.appendItems(itemUUIDs)

        let layout = UICollectionViewLayout()
        let viewModel = ErrorModels.InitialData.ViewModel(description: nil,
                                                          image: nil,
                                                          dataSourceSnapshot: snapshot, layout: layout)
        sut.displayError(viewModel)
        XCTAssertFalse(interactor.isCalledFetchErrorActionData, "Should not start interactor request FetchErrorActionData.")
    }

    func testCollectionDidSelectItem() {
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        sut.collectionView(collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))

        XCTAssertTrue(interactor.isCalledDidSelectErrorAction, "Not started interactor request DidSelectErrorAction.")
    }
}
