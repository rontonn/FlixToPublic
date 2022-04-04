//
//  ConfirmConsumptionTimePurchaseViewControllerTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 17.11.2021.
//

import XCTest
@testable import Flix

final class ConfirmConsumptionTimePurchaseViewControllerTests: XCTestCase {

    // MARK: - Properties
    private var sut: ConfirmConsumptionTimePurchaseViewController!
    private var interactor: ConfirmConsumptionTimePurchaseBusinessLogicSpy!
    private var window: UIWindow!
    private var approveButton: UIButton!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        approveButton = UIButton()
        let mainWindow = UIWindow()

        let viewController = AppScene.confirmConsumptionTimePurchase.viewController(ConfirmConsumptionTimePurchaseViewController.self)
        let interactor = ConfirmConsumptionTimePurchaseBusinessLogicSpy()

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
        approveButton = nil

        super.tearDown()
    }

    // MARK: - Public Methods
    func testViewDidLoad() {
        sut.viewDidLoad()

        XCTAssertTrue(interactor.isCalledFetchPurchaseOption, "Not started interactor request FetchPurchaseOption.")
    }

    func testDidPressApproveButton() {
        sut.didPressApproveButton(approveButton)

        XCTAssertTrue(interactor.isCalledDidPressApproveConsumptionTimePurchase, "Not started interactor request DidPressApproveConsumptionTimePurchase.")
    }
}
