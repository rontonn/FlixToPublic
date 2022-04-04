//
//  EditConsumptionTimeInteractorTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 17.11.2021.
//

import XCTest
@testable import Flix

final class EditConsumptionTimeInteractorTests: XCTestCase {

    // MARK: - Properties
    private var sut: EditConsumptionTimeInteractor!
    private var presenter: EditConsumptionTimePresentationLogicSpy!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let interactor = EditConsumptionTimeInteractor()
        let presenter = EditConsumptionTimePresentationLogicSpy()

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
    func testFetchAvailableConsumptionTime() {
        let request = EditConsumptionTimeModels.InitialData.Request()
        sut.fetchAvailableConsumptionTime(request)

        XCTAssertTrue(presenter.isCalledPresentAvailableConsumptionTime, "Not started present edit available consumption time.")
    }
}
