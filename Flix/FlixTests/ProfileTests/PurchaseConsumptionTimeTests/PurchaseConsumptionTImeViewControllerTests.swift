//
//  PurchaseConsumptionTImeViewControllerTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 17.11.2021.
//

import XCTest
@testable import Flix

final class PurchaseConsumptionTImeViewControllerTests: XCTestCase {

    // MARK: - Properties
    private var sut: PurchaseConsumptionTimeViewController!
    private var interactor: PurchaseConsumptionTImeBusinessLogicSpy!
    private var window: UIWindow!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let mainWindow = UIWindow()

        let viewController = AppScene.purchaseConsumptionTime.viewController(PurchaseConsumptionTimeViewController.self)
        let interactor = PurchaseConsumptionTImeBusinessLogicSpy()

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

        XCTAssertTrue(interactor.isCalledFetchPurchaseOptions, "Not started interactor request FetchPurchaseOptions.")
    }

    func testDisplayEditProfileOption() {
        let layout = PurchaseConsumptionTimeCollectionLayoutSource().createLayout()

        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        snapshot.appendSections([UUID()])
        let itemUUIDs = randomUUIDs()
        snapshot.appendItems(itemUUIDs)

        let viewModel = PurchaseConsumptionTimeModels.InitialData.ViewModel(dataSourceSnapshot: snapshot,
                                                                            layout: layout,
                                                                            availableConsumptionTime: "130")

        sut.displayPurchaseOptions(viewModel)

        let itemsCount = sut.collectionView?.numberOfItems(inSection: 0)
        XCTAssertEqual(itemsCount, itemUUIDs.count)

        XCTAssertTrue(interactor.isCalledFetchPurchaseOption, "Not started interactor request FetchPurchaseOption.")
        XCTAssertTrue(interactor.isCalledFetchSupplementaryView, "Not started interactor request FetchPurchaseOption.")
    }

    func testDisplayEditProfileOptionWithDefaultCollectionViewlayout() {
        let layout = UICollectionViewLayout()

        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        snapshot.appendSections([UUID()])
        let itemUUIDs = randomUUIDs()
        snapshot.appendItems(itemUUIDs)

        let viewModel = PurchaseConsumptionTimeModels.InitialData.ViewModel(dataSourceSnapshot: snapshot,
                                                                            layout: layout,
                                                                            availableConsumptionTime: "130")

        sut.displayPurchaseOptions(viewModel)

        XCTAssertFalse(interactor.isCalledFetchPurchaseOption, "Not started interactor request FetchPurchaseOption.")
        XCTAssertFalse(interactor.isCalledFetchSupplementaryView, "Not started interactor request FetchPurchaseOption.")
    }

    func testDisplayEditProfileOptionWithEmptyOptions() {
        let layout = UICollectionViewLayout()

        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        snapshot.appendSections([UUID()])
        let itemUUIDs = randomUUIDs()
        snapshot.appendItems(itemUUIDs)

        let viewModel = PurchaseConsumptionTimeModels.InitialData.ViewModel(dataSourceSnapshot: snapshot,
                                                                            layout: layout,
                                                                            availableConsumptionTime: "130")

        sut.displayPurchaseOptions(viewModel)

        XCTAssertFalse(interactor.isCalledFetchPurchaseOption, "Should not start interactor request FetchPurchaseOption.")
    }

    func testDidSelectPurchaseOption() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        sut.collectionView(collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))

        XCTAssertTrue(interactor.isCalledDidSelectPurchaseOption, "Not started interactor request DidSelectPurchaseOption.")
    }
}
