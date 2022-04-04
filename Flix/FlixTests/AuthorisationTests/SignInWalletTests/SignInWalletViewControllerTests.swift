//
//  SignInWalletViewControllerTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 17.11.2021.
//

import XCTest
@testable import Flix

final class SignInWalletViewControllerTests: XCTestCase {

    // MARK: - Properties
    private var sut: SignInWalletViewController!
    private var interactor: SignInWalletBusinessLogicSpy!
    private var window: UIWindow!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let mainWindow = UIWindow()

        let viewController = AppScene.signInWallet.viewController(SignInWalletViewController.self)
        let interactor = SignInWalletBusinessLogicSpy()

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

        super.tearDown()
    }

    // MARK: - Public Methods
    func testViewDidLoad() {
        sut.viewDidLoad()

        XCTAssertTrue(interactor.isCalledProvideInitialData, "Not started interactor request provide initial data.")
    }
}
