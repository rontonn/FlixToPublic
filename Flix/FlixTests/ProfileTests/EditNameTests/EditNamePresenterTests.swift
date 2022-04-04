//
//  EditNamePresenterTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 16.11.2021.
//

import XCTest
@testable import Flix

final class EditNamePresenterTests: XCTestCase {

    // MARK: - Properties
    private var sut: EditNamePresenter!
    private var viewController: EditNameDisplayLogicSpy!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let presenter = EditNamePresenter()
        let viewController = EditNameDisplayLogicSpy()

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
    func testPresentCurrentName() {
        let response = EditNameModels.InitialData.Response(name: "")
        sut.presentCurrentName(response)

        XCTAssertTrue(viewController.isCalledDisplayCurrentName, "Not started viewController display current name.")
    }

    func testPresentEditNameSuccess() {
        let response = EditNameModels.Result.Response()
        sut.presentEditNameSuccess(response)

        XCTAssertTrue(viewController.isCalledDisplayEditNameSuccess, "Not started viewController display edit name success.")
    }

    func testPresentEditNameError() {
        let response = EditNameModels.Result.Response()
        sut.presentEditNameError(response)

        XCTAssertTrue(viewController.isCalledDisplayEditNameError, "Not started viewController display edit name error.")
    }
}
