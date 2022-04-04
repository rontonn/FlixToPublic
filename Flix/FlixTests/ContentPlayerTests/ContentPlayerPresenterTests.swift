//
//  ContentPlayerPresenterTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 19.11.2021.
//

import XCTest
@testable import Flix

final class ContentPlayerPresenterTests: XCTestCase {

    // MARK: - Properties
    private var sut: ContentPlayerPresenter!
    private var viewController: ContentPlayerDisplayLogicSpy!

    private var testURL: URL!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let presenter = ContentPlayerPresenter()
        let viewController = ContentPlayerDisplayLogicSpy()

        presenter.viewController = viewController

        sut = presenter
        self.viewController = viewController
        testURL = URL(string: "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8")
    }

    override func tearDown() {
        sut = nil
        viewController = nil
        testURL = nil

        super.tearDown()
    }

    // MARK: - Public Methods
    func testFetchURLToPlay() {
        let request = ContentPlayerModels.InitialData.Response(url: testURL)
        sut.presentContent(request)

        XCTAssertTrue(viewController.isCalledDisplayContent, "Not started display content.")
    }
}
