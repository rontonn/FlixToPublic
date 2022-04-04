//
//  AlertViewControllerTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 19.11.2021.
//

import XCTest
@testable import Flix

final class AlertViewControllerTests: XCTestCase {

    // MARK: - Properties
    private var sut: AlertViewController!
    private var interactor: AlertBusinessLogicSpy!
    private var window: UIWindow!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let mainWindow = UIWindow()

        let viewController = AppScene.alert.viewController(AlertViewController.self)
        let interactor = AlertBusinessLogicSpy()

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

        XCTAssertTrue(interactor.isCalledFetchAlertData, "Not started interactor request FetchAlertData.")
    }

    func testFetchErrorActionData() {
        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        snapshot.appendSections([UUID()])
        let itemUUIDs = randomUUIDs()
        snapshot.appendItems(itemUUIDs)

        let layout = AlertCollectionLayoutSource().createLayout()
        let info = AlertModels.Info(image: nil, title: "", subtitle: nil)
        let viewModel = AlertModels.InitialData.ViewModel(info: info,
                                                          dataSourceSnapshot: snapshot,
                                                          layout: layout)
        sut.displayAlert(viewModel)
        XCTAssertTrue(interactor.isCalledFetchAlertActionData, "Not started interactor request FetchAlertActionData.")
    }

    func testFetchErrorActionDataWithZeroNumberOfItemsInRow() {
        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        snapshot.appendSections([UUID()])

        let layout = AlertCollectionLayoutSource().createLayout()
        let info = AlertModels.Info(image: nil, title: "", subtitle: nil)
        let viewModel = AlertModels.InitialData.ViewModel(info: info,
                                                          dataSourceSnapshot: snapshot,
                                                          layout: layout)
        sut.displayAlert(viewModel)
        XCTAssertFalse(interactor.isCalledFetchAlertActionData, "Should not start interactor request FetchAlertActionData.")
    }

    func testFetchErrorActionDataWithDefaultCollectionViewLayout() {
        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        snapshot.appendSections([UUID()])
        let itemUUIDs = randomUUIDs()
        snapshot.appendItems(itemUUIDs)

        let layout = UICollectionViewLayout()
        let info = AlertModels.Info(image: nil, title: "", subtitle: nil)
        let viewModel = AlertModels.InitialData.ViewModel(info: info,
                                                          dataSourceSnapshot: snapshot,
                                                          layout: layout)
        sut.displayAlert(viewModel)
        XCTAssertFalse(interactor.isCalledFetchAlertActionData, "Should not start interactor request FetchAlertActionData.")
    }

    func testCollectionDidSelectItem() {
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        sut.collectionView(collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))

        XCTAssertTrue(interactor.isCalledDidSelectAlertAction, "Not started interactor request DidSelectAlertAction.")
    }
}
