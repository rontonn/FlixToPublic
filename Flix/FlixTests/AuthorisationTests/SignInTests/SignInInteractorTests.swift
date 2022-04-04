//
//  SignInInteractorTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 17.11.2021.
//

import XCTest
@testable import Flix

final class SignInInteractorTests: XCTestCase {

    // MARK: - Properties
    private var sut: SignInInteractor!
    private var presenter: SignInPresentationLogicSpy!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let interactor = SignInInteractor()
        let presenter = SignInPresentationLogicSpy()

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
    func testFetchSignInOptions() {
        let request = SignInModels.InitialData.Request()
        sut.fetchSignInOptions(request)

        XCTAssertTrue(presenter.isCalledPresentSignInOptions, "Not started present sign in options.")
    }

    func testFetchSignInOption() {
        sut.signInOptions = [SignInOption(option: .qr),
                             SignInOption(option: .wallet)]

        let numberOfItems = sut.signInOptions.count
        let request = SignInModels.SignInOptionData.Request(object: nil,
                                                            indexPath: IndexPath(item: numberOfItems - 1, section: 0))
        sut.fetchSignInOption(request)

        XCTAssertTrue(presenter.isCalledPresentSignInOption, "Not started present SignInOptionData.")
    }

    func testFetchSignInOptionWithoutOptions() {
        let request = SignInModels.SignInOptionData.Request(object: nil,
                                                            indexPath: IndexPath(item: 0, section: 0))
        sut.fetchSignInOption(request)

        XCTAssertFalse(presenter.isCalledPresentSignInOption, "Should not start present SignInOptionData.")
    }

    func testDidSelectPurchaseOption() {
        let signInOptions = [SignInOption(option: .qr),
                             SignInOption(option: .wallet)]

        sut.signInOptions = signInOptions
        let selectedIndex = 1

        let request = SignInModels.SelectSignInOption.Request(indexPath: IndexPath(item: selectedIndex, section: 0))
        sut.didSelectSignInOption(request)

        XCTAssertTrue(presenter.isCalledPresentSelectedSignInOption, "Not started present SelectedSignInOption.")
    }

    func testDidSelectMovieFailed() {
        let numberOfItems = sut.signInOptions.count
        let request = SignInModels.SelectSignInOption.Request(indexPath: IndexPath(item: numberOfItems, section: 0))
        sut.didSelectSignInOption(request)

        XCTAssertFalse(presenter.isCalledPresentSelectedSignInOption, "Should not started present SelectedSignInOption.")
    }
}
