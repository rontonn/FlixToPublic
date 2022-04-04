//
//  SignInWalletPresenterTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 17.11.2021.
//

import XCTest
@testable import Flix

final class SignInWalletPresenterTests: XCTestCase {

    // MARK: - Properties
    private var sut: SignInWalletPresenter!
    private var viewController: SignInWalletDisplayLogicSpy!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let presenter = SignInWalletPresenter()
        let viewController = SignInWalletDisplayLogicSpy()

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
    func testPresentInitialData() {
        let response = SignInWalletModels.InitialData.Response(pageTitle: "", qrImage: nil)
        sut.presentInitialData(response)

        XCTAssertTrue(viewController.isCalledDisplayInitialData, "Not started viewController display initial data.")
    }
}
