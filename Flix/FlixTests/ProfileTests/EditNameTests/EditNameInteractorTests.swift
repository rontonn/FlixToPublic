//
//  EditNameInteractorTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 16.11.2021.
//

import XCTest
@testable import Flix

final class EditNameInteractorTests: XCTestCase {

    // MARK: - Properties
    private var sut: EditNameInteractor!
    private var presenter: EditNamePresentationLogicSpy!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let interactor = EditNameInteractor()
        let presenter = EditNamePresentationLogicSpy()

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
    func testFetchCurrentName() {
        let request = EditNameModels.InitialData.Request()
        sut.fetchCurrentName(request)

        XCTAssertTrue(presenter.isCalledPresentCurrentName, "Not started present current name.")
    }

    func testEditNameSuccess() {
        let request = EditNameModels.Result.Request(newName: "Anton")
        sut.didPressSaveNameButton(request)

        XCTAssertTrue(presenter.isCalledPresentEditNameSuccess, "Not started present edit name success.")
    }

    func testEditNameErrorEmptyName() {
        let request = EditNameModels.Result.Request(newName: "")
        sut.didPressSaveNameButton(request)

        XCTAssertTrue(presenter.isCalledPresentEditNameError, "Not started present edit name error 'Empty name'.")
    }

    func testEditNameErrorSameName() {
        sut.currentName = "Old name"
        let request = EditNameModels.Result.Request(newName: "Old name")
        sut.didPressSaveNameButton(request)

        XCTAssertTrue(presenter.isCalledPresentEditNameError, "Not started present edit name error 'Same name'.")
    }
}
