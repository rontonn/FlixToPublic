//
//  SignInPresenterTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 17.11.2021.
//

import XCTest
@testable import Flix

final class SignInPresenterTests: XCTestCase {

    // MARK: - Properties
    private var sut: SignInPresenter!
    private var viewController: SignInDisplayLogicSpy!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let presenter = SignInPresenter()
        let viewController = SignInDisplayLogicSpy()

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
    func testPresentSignInOptions() {
        let response = SignInModels.InitialData.Response(signInOptions: [])
        sut.presentSignInOptions(response)

        XCTAssertTrue(viewController.isCalledDisplaySignInOptions, "Not started viewController display sign in options.")
    }

    func testPresentSignInOption() {
        let response = SignInModels.SignInOptionData.Response(object: nil, signInOption: SignInOption(option: .wallet))
        sut.presentSignInOption(response)

        XCTAssertTrue(viewController.isCalledDisplaySignInOption, "Not started viewController display sign in option.")
    }

    func testPresentSelectedSignInOptionWallet() {
        let response = SignInModels.SelectSignInOption.Response(option: .wallet)
        sut.presentSelectedSignInOption(response)

        XCTAssertTrue(viewController.isCalledDisplaySignInWithWallet, "Not started viewController DisplaySignInWithWallet.")
        XCTAssertFalse(viewController.isCalledDisplaySignInWithQR, "Should not start viewController DisplaySignInWithQR.")
    }

    func testPresentSelectedSignInOptionQR() {
        let response = SignInModels.SelectSignInOption.Response(option: .qr)
        sut.presentSelectedSignInOption(response)

        XCTAssertFalse(viewController.isCalledDisplaySignInWithWallet, "Should not start viewController DisplaySignInWithWallet.")
        XCTAssertTrue(viewController.isCalledDisplaySignInWithQR, "Not started viewController DisplaySignInWithQR.")
    }
}
