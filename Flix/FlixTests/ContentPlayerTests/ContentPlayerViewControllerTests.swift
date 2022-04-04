//
//  ContentPlayerViewControllerTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 19.11.2021.
//

import XCTest
@testable import Flix
import AVFoundation

final class ContentPlayerViewControllerTests: XCTestCase {

    // MARK: - Properties
    private var sut: ContentPlayerViewController!
    private var interactor: ContentPlayerBusinessLogicSpy!
    private var window: UIWindow!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let mainWindow = UIWindow()

        let viewController = AppScene.contentPlayer.viewController(ContentPlayerViewController.self)
        let interactor = ContentPlayerBusinessLogicSpy()

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
    func testViewDidLoad() async {
        await sut.viewDidLoad()

        XCTAssertTrue(interactor.isCalledFetchURLToPlay, "Not started interactor request FetchURLToPlay.")
    }
}
