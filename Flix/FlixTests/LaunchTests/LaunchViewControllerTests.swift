//
//  LaunchViewControllerTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 15.11.2021.
//

import XCTest
@testable import Flix

final class LaunchViewControllerTests: XCTestCase {
    // MARK: - Properties
    private var sut: LaunchViewController!
    private var interactor: LaunchBusinessLogicSpy!
    private var window: UIWindow!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let mainWindow = UIWindow()
        let viewController = AppScene.launch.viewController(LaunchViewController.self)
        let interactor = LaunchBusinessLogicSpy()

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

    // MARK: - Public methods
    func testViewDidLoad() {
        sut.viewDidLoad()

        XCTAssertTrue(interactor.isCalledRequestPageTitle, "Not started interactor request page title.")
    }
}
