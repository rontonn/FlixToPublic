//
//  PurchaseConsumptionTImePresenterTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 17.11.2021.
//

import XCTest
@testable import Flix

final class PurchaseConsumptionTImePresenterTests: XCTestCase {

    // MARK: - Properties
    private var sut: PurchaseConsumptionTimePresenter!
    private var viewController: PurchaseConsumptionTImeDisplayLogicSpy!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let presenter = PurchaseConsumptionTimePresenter()
        let viewController = PurchaseConsumptionTImeDisplayLogicSpy()

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
    func testPresentPurchaseOptions() {
        let response = PurchaseConsumptionTimeModels.InitialData.Response(purchaseOptions: [], availableConsumptionTime: "")
        sut.presentPurchaseOptions(response)

        XCTAssertTrue(viewController.isCalledDisplayPurchaseOptions, "Not started viewController display purchase consumption time options.")
    }

    func testPresentPurchaseOption() {
        let response = PurchaseConsumptionTimeModels.PurchaseConsumptionTimeOptionData.Response(object: nil, option: .init(hours: 0, price: 0, reward: 0))
        sut.presentPurchaseOption(response)

        XCTAssertTrue(viewController.isCalledDisplayPurchaseOption, "Not started viewController display purchase consumption time option.")
    }

    func testPresentSupplementaryView() {
        let header = PurchaseConsumptionTimeSupplementaryView.Header(title: nil, subtitle: nil, accessoryImage: nil)
        let response = PurchaseConsumptionTimeModels.PurchaseConsumptionTimeSupplementaryViewData.Response(object: nil, header: header)
        sut.presentSupplementaryView(response)

        XCTAssertTrue(viewController.isCalledDisplaySupplementaryView, "Not started viewController display supplementary view.")
    }

    func testPresentSelectedPurchaseOption() {
        let response = PurchaseConsumptionTimeModels.SelectedPurchaseOption.Response()
        sut.presentSelectedPurchaseOption(response)

        XCTAssertTrue(viewController.isCalledDisplaySelectedPurchaseOption, "Not started viewController display selected purchase option.")
    }
}
