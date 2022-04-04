//
//  PurchaseConsumptionTImeInteractorTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 17.11.2021.
//

import XCTest
@testable import Flix

final class PurchaseConsumptionTImeInteractorTests: XCTestCase {

    // MARK: - Properties
    private var sut: PurchaseConsumptionTimeInteractor!
    private var presenter: PurchaseConsumptionTImePresentationLogicSpy!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let interactor = PurchaseConsumptionTimeInteractor()
        let presenter = PurchaseConsumptionTImePresentationLogicSpy()

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
    func testFetchPurchaseOptions() {
        let request = PurchaseConsumptionTimeModels.InitialData.Request()
        sut.fetchPurchaseOptions(request)

        XCTAssertTrue(presenter.isCalledPresentPurchaseOptions, "Not started present purchase consumption time options.")
    }

    func testFetchPurchaseOption() {
        let purchaseOptions = [PurchaseConsumptionTimeOption(hours: 20, price: 240, reward: 10),
                               PurchaseConsumptionTimeOption(hours: 30, price: 260, reward: 20)]
        sut.purchaseOptions = purchaseOptions
        let request = PurchaseConsumptionTimeModels.PurchaseConsumptionTimeOptionData.Request(object: nil, indexPath: IndexPath(item: purchaseOptions.count - 1, section: 0))
        sut.fetchPurchaseOption(request)

        XCTAssertTrue(presenter.isCalledPresentPurchaseOption, "Not started present purchase consumption time option.")
    }

    func testDidSelectPurchaseOptionFailed() {
        let numberOfImtems = sut.purchaseOptions.count
        let request = PurchaseConsumptionTimeModels.SelectedPurchaseOption.Request(indexPath: IndexPath(item: numberOfImtems, section: 0))
        sut.didSelectPurchaseOption(request)

        XCTAssertFalse(presenter.isCalledPresentSelectedPurchaseOption, "Should not started present selectedPurchaseOption.")
    }

    func testFetchSupplementaryView() {
        let request = PurchaseConsumptionTimeModels.PurchaseConsumptionTimeSupplementaryViewData.Request(object: nil, indexPath: IndexPath(item: 0, section: 0))
        sut.fetchSupplementaryView(request)

        XCTAssertTrue(presenter.isCalledPresentSupplementaryView, "Not started present supplementary view.")
    }

    func testDidSelectPurchaseOption() {
        let purchaseOptions = [PurchaseConsumptionTimeOption(hours: 20, price: 240, reward: 10),
                               PurchaseConsumptionTimeOption(hours: 30, price: 260, reward: 20),
                               PurchaseConsumptionTimeOption(hours: 40, price: 280, reward: 30),
                               PurchaseConsumptionTimeOption(hours: 50, price: 300, reward: 40),
                               PurchaseConsumptionTimeOption(hours: 60, price: 320, reward: 50),
                               PurchaseConsumptionTimeOption(hours: 70, price: 340, reward: 60)]
        sut.purchaseOptions = purchaseOptions
        let selectedIndex = 3
        let selectedPurchaseOptionID = purchaseOptions[selectedIndex].id
        let selectedPurchaseOptionHours = purchaseOptions[selectedIndex].hours

        let request = PurchaseConsumptionTimeModels.SelectedPurchaseOption.Request(indexPath: IndexPath(item: selectedIndex, section: 0))
        sut.didSelectPurchaseOption(request)

        XCTAssertEqual(sut.selectedPurchaseOption?.id, selectedPurchaseOptionID)
        XCTAssertEqual(sut.selectedPurchaseOption?.hours, selectedPurchaseOptionHours)
        XCTAssertTrue(presenter.isCalledPresentSelectedPurchaseOption, "Not started present selectedPurchaseOption.")
    }
}
