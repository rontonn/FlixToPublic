//
//  AlertInteractorTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 19.11.2021.
//

import XCTest
@testable import Flix

final class AlertInteractorTests: XCTestCase {

    // MARK: - Properties
    private var sut: AlertInteractor!
    private var presenter: AlertPresentationLogicSpy!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let interactor = AlertInteractor()
        let presenter = AlertPresentationLogicSpy()

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
    func testFetchContentInfo() {
        let request = AlertModels.InitialData.Request()
        let info = AlertModels.Info(image: nil, title: "", subtitle: "")
        sut.info = info
        sut.fetchAlertData(request)

        XCTAssertTrue(presenter.isCalledPresentAlert, "Not started present alert.")
    }

    func testFetchAlertActionData() {
        sut.actions = [AlertAction(option: .close),
                       AlertAction(option: .close)]

        let numberOfItems = sut.actions.count
        let request = AlertModels.AlertActionData.Request(object: nil,
                                                          indexPath: IndexPath(item: numberOfItems - 1, section: 0))
        sut.fetchAlertActionData(request)

        XCTAssertTrue(presenter.isCalledPresentAlertActionData, "Not started PresentAlertActionData.")
    }

    func testFetchAlertActionDataWithoutActions() {
        let request = AlertModels.AlertActionData.Request(object: nil,
                                                          indexPath: IndexPath(item: 0, section: 0))
        sut.fetchAlertActionData(request)

        XCTAssertFalse(presenter.isCalledPresentAlertActionData, "Should not start PresentAlertActionData.")
    }

    func testFetchContentInfoWithoutAlert() {
        let request = AlertModels.InitialData.Request()
        sut.fetchAlertData(request)

        XCTAssertFalse(presenter.isCalledPresentAlert, "Should not start present alert.")
    }

    func testRequestDidSelectAlertAction() {
        sut.actions = [AlertAction(option: .close)]
        let numberOfAlertActions = sut.actions.count
        let request = AlertModels.SelectAlertAction.Request(indexPath: IndexPath(item: numberOfAlertActions - 1, section: 0))
        sut.didSelectAlertAction(request)

        XCTAssertTrue(presenter.isCalledPresentSelectedAlertAction, "Not started present PresentAlertAction.")
    }

    func testRequestDidSelectAlertActionWithoutAlertActions() {
        let request = AlertModels.SelectAlertAction.Request(indexPath: IndexPath(item: 0, section: 0))
        sut.didSelectAlertAction(request)

        XCTAssertFalse(presenter.isCalledPresentSelectedAlertAction, "Should not start present PresentAlertAction.")
    }
}
