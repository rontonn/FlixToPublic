//
//  ConfirmConsumptionTimePurchasePresenterTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 17.11.2021.
//

import XCTest
@testable import Flix

final class ConfirmConsumptionTimePurchasePresenterTests: XCTestCase {

    // MARK: - Properties
    private var sut: ConfirmConsumptionTimePurchasePresenter!
    private var viewController: ConfirmConsumptionTimePurchaseDisplayLogicSpy!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let presenter = ConfirmConsumptionTimePurchasePresenter()
        let viewController = ConfirmConsumptionTimePurchaseDisplayLogicSpy()

        presenter.viewController = viewController

        sut = presenter
        self.viewController = viewController
    }

    override func tearDown() {
        sut = nil
        viewController = nil

        super.tearDown()
    }

    // MARK: - Public Methods
    func testFetchPurchaseOption() {
        let response = ConfirmConsumptionTimePurchaseModels.InitialData.Response(purchaseOption: .init(hours: 5, price: 5, reward: 5))
        sut.presentPurchaseOption(response)

        XCTAssertTrue(viewController.isCalledDisplayPurchaseOption, "Not started viewController display confirmed purchase option.")
    }

    func testDidApprovedConsumptionTimePurchase() {
        let response = ConfirmConsumptionTimePurchaseModels.MakePurchase.Response()
        sut.didCompletePurchase(response)

        XCTAssertTrue(viewController.isCalledDidCompletePurchase, "Not started viewController did complete purchase.")
    }
}
