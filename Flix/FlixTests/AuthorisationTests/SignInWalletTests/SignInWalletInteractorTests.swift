//
//  SignInWalletInteractorTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 17.11.2021.
//

import XCTest
@testable import Flix

final class SignInWalletInteractorTests: XCTestCase {

    // MARK: - Properties
    private var sut: SignInWalletInteractor!
    private var qrCodeWorker: QRCodeWorkerWorkerLogicSpy!
    private var presenter: SignInWalletPresentationLogicSpy!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let interactor = SignInWalletInteractor()
        let qrCodeWorker = QRCodeWorkerWorkerLogicSpy()
        let presenter = SignInWalletPresentationLogicSpy()

        interactor.presenter = presenter
        interactor.qrCodeWorker = qrCodeWorker

        sut = interactor
        self.qrCodeWorker = qrCodeWorker
        self.presenter = presenter
    }

    override func tearDown() {
        sut = nil
        qrCodeWorker = nil
        presenter = nil

        super.tearDown()
    }

    // MARK: - Public Methods
    func testProvideInitialData() {
        let request = SignInWalletModels.InitialData.Request()
        sut.provideInitialData(request)

        XCTAssertTrue(presenter.isCalledPresentInitialData, "Not started present initial data.")
        XCTAssertTrue(qrCodeWorker.isCalledQrCodeImage, "Not started qrCodeWorker,qrCodeImage.")
    }
}
