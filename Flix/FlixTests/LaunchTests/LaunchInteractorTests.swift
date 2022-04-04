//
//  LaunchInteractorTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 15.11.2021.
//

import XCTest
@testable import Flix

final class LaunchInteractorTests: XCTestCase {
    // MARK: - Properties
    private var sut: LaunchInteractor!
    private var presenter: LaunchPresentationLogicSpy!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let launchInteractor = LaunchInteractor()
        let launchPresenter = LaunchPresentationLogicSpy()

        launchInteractor.presenter = launchPresenter

        sut = launchInteractor
        presenter = launchPresenter
    }

    override func tearDown() {
        sut = nil
        presenter = nil

        super.tearDown()
    }

    // MARK: - Public methods
    func testRequestPageTitle() {
        let request = LaunchModels.InitialData.Request()
        sut.requestPageTitle(request)

        XCTAssertTrue(presenter.isCalledPresentPageTitle, "Not started present page title.")
    }
}
