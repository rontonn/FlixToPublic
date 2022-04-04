//
//  ConfirmConsumptionTimePurchaseInteractorTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 17.11.2021.
//

import XCTest
@testable import Flix

final class ConfirmConsumptionTimePurchaseInteractorTests: XCTestCase {

    // MARK: - Properties
    private var sut: ConfirmConsumptionTimePurchaseInteractor!
    private var presenter: ConfirmConsumptionTimePurchasePresentationLogicSpy!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let interactor = ConfirmConsumptionTimePurchaseInteractor()
        let presenter = ConfirmConsumptionTimePurchasePresentationLogicSpy()

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
    func testFetchPurchaseOption() {
        let request = ConfirmConsumptionTimePurchaseModels.InitialData.Request()
        sut.purchaseOption = .init(hours: 5, price: 5, reward: 5)
        sut.fetchPurchaseOption(request)

        XCTAssertTrue(presenter.isCalledPresentPurchaseOption, "Not started present confirmed purchase option.")
    }

    func testFetchPurchaseOptionFailed() {
        let request = ConfirmConsumptionTimePurchaseModels.InitialData.Request()
        sut.fetchPurchaseOption(request)

        XCTAssertFalse(presenter.isCalledPresentPurchaseOption, "Should not start present confirmed purchase option.")
    }

    func testDidApproveConsumptionTimePurchase() {
        let expectation = XCTestExpectation(description: "APPROVE CONSUMPTION REQUEST")
        let request = ConfirmConsumptionTimePurchaseModels.MakePurchase.Request()
        sut.didPressApproveConsumptionTimePurchase(request)

        Task(priority: .utility) {
            try? await Task.sleep(nanoseconds: 4_000_000_000)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10)
        XCTAssertTrue(presenter.isCalledDidCompletePurchase, "Not started present did complete purchase.")
    }
}
