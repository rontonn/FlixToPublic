//
//  EditNameViewControllerTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 16.11.2021.
//

import XCTest
@testable import Flix

final class EditNameViewControllerTests: XCTestCase {

    // MARK: - Properties
    private var sut: EditNameViewController!
    private var interactor: EditNameBusinessLogicSpy!
    private var window: UIWindow!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let mainWindow = UIWindow()

        let viewController = AppScene.editName.viewController(EditNameViewController.self)
        let interactor = EditNameBusinessLogicSpy()

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

        XCTAssertTrue(interactor.isCalledFetchCurrentName, "Not started interactor request FetchCurrentName.")
    }

    func testDidPressSaveNameButton() {
        let button = UIButton()
        sut.saveButtonPressed(button)
        XCTAssertTrue(interactor.isCalledDidPressSaveNameButton, "Not started interactor request DidPressSaveNameButton.")
    }
}
