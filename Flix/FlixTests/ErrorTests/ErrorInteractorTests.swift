//
//  ErrorInteractorTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 19.11.2021.
//

import XCTest
@testable import Flix

final class ErrorInteractorTests: XCTestCase {

    // MARK: - Properties
    private var sut: ErrorInteractor!
    private var presenter: ErrorPresentationLogicSpy!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let interactor = ErrorInteractor()
        let presenter = ErrorPresentationLogicSpy()

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
    func testFetchErrorInfo() {
        let request = ErrorModels.InitialData.Request()
        let error = PriviError(title: "", msg: "")
        sut.error = error
        sut.fetchErrorInfo(request)

        XCTAssertTrue(presenter.isCalledPresentError, "Not started present error.")
    }

    func testFetchErrorInfoWithoutError() {
        let request = ErrorModels.InitialData.Request()
        sut.fetchErrorInfo(request)

        XCTAssertFalse(presenter.isCalledPresentError, "Should not start present error.")
    }

    func testFetchErrorActionData() {
        let actions = [PriviErrorAction(option: .close),
                       PriviErrorAction(option: .solution)]
        sut.error = PriviError(title: "", msg: "", actions: actions)

        let numberOfItems = actions.count
        let request = ErrorModels.ErrorActionData.Request(object: nil,
                                                          indexPath: IndexPath(item: numberOfItems - 1, section: 0))
        sut.fetchErrorActionData(request)

        XCTAssertTrue(presenter.isCalledPresentErrorActionData, "Not started PresentErrorActionData.")
    }

    func testFetchErrorActionDataWithoutActions() {
        let request = ErrorModels.ErrorActionData.Request(object: nil,
                                                          indexPath: IndexPath(item: 0, section: 0))
        sut.fetchErrorActionData(request)

        XCTAssertFalse(presenter.isCalledPresentErrorActionData, "Should not start PresentErrorActionData.")
    }

    func testRequestDidSelectErrorAction() {
        let error = PriviError(title: "",
                               msg: "",
                               actions: [PriviErrorAction(option: .close),
                                         PriviErrorAction(option: .solution)])
        sut.error = error
        let numberOfErrorActons = sut.error!.actions.count
        let request = ErrorModels.SelectErrorAction.Request(indexPath: IndexPath(item: numberOfErrorActons - 1, section: 0))
        sut.didSelectErrorAction(request)

        XCTAssertTrue(presenter.isCalledPresentSelectedErrorAction, "Not started present PresentSelectedErrorAction.")
    }

    func testRequestDidSelectErrorActionWithoutErrorActions() {
        let request = ErrorModels.SelectErrorAction.Request(indexPath: IndexPath(item: 0, section: 0))
        sut.didSelectErrorAction(request)

        XCTAssertFalse(presenter.isCalledPresentSelectedErrorAction, "Should not start present PresentSelectedErrorAction.")
    }
}
