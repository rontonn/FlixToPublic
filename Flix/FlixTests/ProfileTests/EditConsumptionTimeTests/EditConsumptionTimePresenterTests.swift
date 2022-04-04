//
//  EditConsumptionTimePresenterTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 17.11.2021.
//

import XCTest
@testable import Flix

final class EditConsumptionTimePresenterTests: XCTestCase {

    // MARK: - Properties
    private var sut: EditConsumptionTimePresenter!
    private var viewController: EditConsumptionTimeDisplayLogicSpy!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let presenter = EditConsumptionTimePresenter()
        let viewController = EditConsumptionTimeDisplayLogicSpy()

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
    func testPresentAvailableConsumptionTime() {
        let response = EditConsumptionTimeModels.InitialData.Response(availableConsumptionTime: "")
        sut.presentAvailableConsumptionTime(response)

        XCTAssertTrue(viewController.isCalledDisplayAvailableConsumptionTime, "Not started viewController display edit available consumption time.")
    }
}
