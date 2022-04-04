//
//  AlertPresenterTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 19.11.2021.
//

import XCTest
@testable import Flix

final class AlertPresenterTests: XCTestCase {

    // MARK: - Properties
    private var sut: AlertPresenter!
    private var viewController: AlertDisplayLogicSpy!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let presenter = AlertPresenter()
        let viewController = AlertDisplayLogicSpy()

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
        let info = AlertModels.Info(image: nil, title: "", subtitle: "")
        let response = AlertModels.InitialData.Response(info: info, actions: [])
        sut.presentAlert(response)

        XCTAssertTrue(viewController.isCalledDisplayAlert, "Not started viewControler display alert.")
    }

    func testPresentSceneTab() {
        let response = AlertModels.AlertActionData.Response(object: nil, action: AlertAction(option: .close))
        sut.presentAlertActionData(response)

        XCTAssertTrue(viewController.isCalledDisplayAlertActionData, "Not started viewController DisplayAlertActionData.")
    }

    func  testPresentAlertAction() {
        let response = AlertModels.SelectAlertAction.Response(action: AlertAction(option: .close))
        sut.presentSelectedAlertAction(response)

        XCTAssertTrue(viewController.isCalledCloseAlert, "Not started viewControler CloseAlert.")
    }
}
