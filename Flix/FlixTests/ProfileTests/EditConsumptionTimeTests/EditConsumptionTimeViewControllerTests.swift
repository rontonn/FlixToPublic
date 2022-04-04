//
//  EditConsumptionTimeViewControllerTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 17.11.2021.
//

import XCTest
@testable import Flix

final class EditConsumptionTimeViewControllerTests: XCTestCase {

    // MARK: - Properties
    private var sut: EditConsumptionTimeViewController!
    private var interactor: EditConsumptionTimeBusinessLogicSpy!
    private var window: UIWindow!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let mainWindow = UIWindow()

        let viewController = AppScene.editConsumptionTime.viewController(EditConsumptionTimeViewController.self)
        let interactor = EditConsumptionTimeBusinessLogicSpy()

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

        XCTAssertTrue(interactor.isCalledFetchAvailableConsumptionTime, "Not started interactor request FetchAvailableConsumptionTime.")
    }
}
