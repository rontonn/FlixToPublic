//
//  ErrorPresenterTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 19.11.2021.
//

import XCTest
@testable import Flix

final class ErrorPresenterTests: XCTestCase {

    // MARK: - Properties
    private var sut: ErrorPresenter!
    private var viewController: ErrorDisplayLogicSpy!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let presenter = ErrorPresenter()
        let viewController = ErrorDisplayLogicSpy()

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
    func testFetchContentInfo() {
        let error = PriviError(title: "", msg: "")
        let response = ErrorModels.InitialData.Response(error: error)
        sut.presentError(response)

        XCTAssertTrue(viewController.isCalledDisplayError, "Not started viewControler display error.")
    }

    func testPresentSceneTab() {
        let response = ErrorModels.ErrorActionData.Response(object: nil, action: PriviErrorAction(option: .close))
        sut.presentErrorActionData(response)

        XCTAssertTrue(viewController.isCalledDisplayErrorActionData, "Not started viewController DisplayErrorActionData.")
    }

    func  testPresentCloseAction() {
        let response = ErrorModels.SelectErrorAction.Response(action: PriviErrorAction(option: .close))
        sut.presentSelectedErrorAction(response)

        XCTAssertTrue(viewController.isCalledCloseError, "Not started viewControler CloseError.")
        XCTAssertFalse(viewController.isCalledPerformSolutionOnError, "Should not start viewControler PerformSolutionOnError.")
    }

    func  testPresentSolutionAction() {
        let response = ErrorModels.SelectErrorAction.Response(action: PriviErrorAction(option: .solution))
        sut.presentSelectedErrorAction(response)

        XCTAssertFalse(viewController.isCalledCloseError, "Should not start viewControler CloseError.")
        XCTAssertTrue(viewController.isCalledPerformSolutionOnError, "Not started viewControler PerformSolutionOnError.")
    }
}
