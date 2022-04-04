//
//  LaunchPresenterTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 15.11.2021.
//

import XCTest
@testable import Flix

final class LaunchPresenterTests: XCTestCase {
    // MARK: - Properties
    private var sut: LaunchPresenter!
    private var viewController: LaunchDisplayLogicSpy!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let launchPresentor = LaunchPresenter()
        let launchDisplay = LaunchDisplayLogicSpy()

        launchPresentor.viewController = launchDisplay

        sut = launchPresentor
        viewController = launchDisplay
    }

    override func tearDown() {
        sut = nil
        viewController = nil

        super.tearDown()
    }

    // MARK: - Public methods
    func testPresetPageTitle() {
        let response = LaunchModels.InitialData.Response()
        sut.presentPageTitle(response)

        XCTAssertTrue(viewController.isCalledDisplayTitle, "Not started display page title.")
    }
}
