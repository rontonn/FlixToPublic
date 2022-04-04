//
//  VideoOnDemandDetailsInteractorTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 17.11.2021.
//

import XCTest
@testable import Flix

final class VideoOnDemandDetailsInteractorTests: XCTestCase {

    // MARK: - Properties
    private var sut: VideoOnDemandDetailsInteractor!
    private var presenter: VideoOnDemandDetailsPresentationLogicSpy!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let interactor = VideoOnDemandDetailsInteractor()
        let presenter = VideoOnDemandDetailsPresentationLogicSpy()

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
    func testFetchVideoOnDemandDetails() {
        let request = VideoOnDemandDetailsModels.InitialData.Request()
        sut.fetchVideoOnDemandDetails(request)

        XCTAssertTrue(presenter.isCalledPresentVideoOnDemandDetails, "Not started present video on demand content details.")
    }

    func testFetchVideoOnDemandDetailsAction() {
        sut.actions = [VideoOnDemandDetailsAction(option: .rate),
                       VideoOnDemandDetailsAction(option: .play)]

        let numberOfItems = sut.actions.count
        let request = VideoOnDemandDetailsModels.Action.Request(object: nil,
                                                                indexPath: IndexPath(item: numberOfItems - 1, section: 0))
        sut.fetchVideoOnDemandDetailsAction(request)

        XCTAssertTrue(presenter.isCalledPresentVideoOnDemandDetailsAction, "Not started PresentVideoOnDemandDetailsAction.")
    }

    func testFetchVideoOnDemandDetailsActionWithoutActions() {
        let request = VideoOnDemandDetailsModels.Action.Request(object: nil,
                                                                indexPath: IndexPath(item: 0, section: 0))
        sut.fetchVideoOnDemandDetailsAction(request)

        XCTAssertFalse(presenter.isCalledPresentVideoOnDemandDetailsAction, "Should not start PresentVideoOnDemandDetailsAction.")
    }

    func testDidSelectVideoOnDemandDetailsAction() {
        sut.actions = [VideoOnDemandDetailsAction(option: .rate),
                       VideoOnDemandDetailsAction(option: .play)]
        let numberOfItems = sut.actions.count - 1
        let request = VideoOnDemandDetailsModels.SelectVideoOnDemandDetailsAction.Request(indexPath: IndexPath(item: numberOfItems, section: 0))
        sut.didSelectVideoOnDemandDetailsAction(request)

        XCTAssertTrue(presenter.isCalledPresentSelectedVideoOnDemandDetailsAction, "Not started present selected video on demand action.")
    }

    func testDidSelectVideoOnDemandDetailsActionWithoutOptions() {
        let numberOfItems = sut.actions.count
        let request = VideoOnDemandDetailsModels.SelectVideoOnDemandDetailsAction.Request(indexPath: IndexPath(item: numberOfItems, section: 0))
        sut.didSelectVideoOnDemandDetailsAction(request)

        XCTAssertFalse(presenter.isCalledPresentSelectedVideoOnDemandDetailsAction, "Should not start present selected video on demand action.")
    }
}
