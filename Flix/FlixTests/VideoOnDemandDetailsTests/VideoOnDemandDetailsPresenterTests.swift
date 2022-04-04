//
//  VideoOnDemandDetailsPresenterTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 17.11.2021.
//

import XCTest
@testable import Flix

final class VideoOnDemandDetailsPresenterTests: XCTestCase {

    // MARK: - Properties
    private var sut: VideoOnDemandDetailsPresenter!
    private var viewController: VideoOnDemandDetailsDisplayLogicSpy!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let presenter = VideoOnDemandDetailsPresenter()
        let viewController = VideoOnDemandDetailsDisplayLogicSpy()

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
    func testPresentVideoOnDemandDetails() {
        let response = VideoOnDemandDetailsModels.InitialData.Response(videoOnDemandItem: nil, actions: [])
        sut.presentVideoOnDemandDetails(response)

        XCTAssertTrue(viewController.isCalledDisplayVideoOnDemandDetails, "Not started viewController display video on demand details action options.")
    }

    func testPresentVideoOnDemandDetailsAction() {
        let response = VideoOnDemandDetailsModels.Action.Response(object: nil, action: VideoOnDemandDetailsAction(option: .play))
        sut.presentVideoOnDemandDetailsAction(response)

        XCTAssertTrue(viewController.isCalledDisplayVideoOnDemandDetailsAction, "Not started viewController DisplayVideoOnDemandDetailsAction.")
    }

    func testPresentSelectedActionPlay() {
        let response = VideoOnDemandDetailsModels.SelectVideoOnDemandDetailsAction.Response(option: .play)
        sut.presentSelectedVideoOnDemandDetailsAction(response)

        XCTAssertTrue(viewController.isCalledDisplayContentPlayer, "Not started viewController DisplayContentPlayer.")
        XCTAssertFalse(viewController.isCalledDisplayRateContent, "Should no start viewController DisplayRateContent.")
        XCTAssertFalse(viewController.isCalledDisplayWatchLater, "Should no start viewController DisplayWatchLater.")
        XCTAssertFalse(viewController.isCalledDisplayMoreEpisodes, "Should no start viewController DisplayMoreEpisodes.")
    }

    func testPresentSelectedActionRate() {
        let response = VideoOnDemandDetailsModels.SelectVideoOnDemandDetailsAction.Response(option: .rate)
        sut.presentSelectedVideoOnDemandDetailsAction(response)

        XCTAssertFalse(viewController.isCalledDisplayContentPlayer, "Should no start viewController DisplayContentPlayer.")
        XCTAssertTrue(viewController.isCalledDisplayRateContent, "Not started viewController DisplayRateContent.")
        XCTAssertFalse(viewController.isCalledDisplayWatchLater, "Should no start viewController DisplayWatchLater.")
        XCTAssertFalse(viewController.isCalledDisplayMoreEpisodes, "Should no start viewController DisplayMoreEpisodes.")
    }

    func testPresentSelectedActionWatchLater() {
        let response = VideoOnDemandDetailsModels.SelectVideoOnDemandDetailsAction.Response(option: .watchLater)
        sut.presentSelectedVideoOnDemandDetailsAction(response)

        XCTAssertFalse(viewController.isCalledDisplayContentPlayer, "Should no start viewController DisplayContentPlayer.")
        XCTAssertFalse(viewController.isCalledDisplayRateContent, "Should no start viewController DisplayRateContent.")
        XCTAssertTrue(viewController.isCalledDisplayWatchLater, "Not started viewController DisplayWatchLater.")
        XCTAssertFalse(viewController.isCalledDisplayMoreEpisodes, "Should no start viewController DisplayMoreEpisodes.")
    }

    func testPresentSelectedActionMoreEpisodes() {
        let response = VideoOnDemandDetailsModels.SelectVideoOnDemandDetailsAction.Response(option: .moreEpisodes)
        sut.presentSelectedVideoOnDemandDetailsAction(response)

        XCTAssertFalse(viewController.isCalledDisplayContentPlayer, "Should no start viewController DisplayContentPlayer.")
        XCTAssertFalse(viewController.isCalledDisplayRateContent, "Should no start viewController DisplayRateContent.")
        XCTAssertFalse(viewController.isCalledDisplayWatchLater, "Should no start viewController DisplayWatchLater.")
        XCTAssertTrue(viewController.isCalledDisplayMoreEpisodes, "Not started viewController DisplayMoreEpisodes.")
    }
}
