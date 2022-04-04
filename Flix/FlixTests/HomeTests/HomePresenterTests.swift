//
//  HomePresenterTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 15.11.2021.
//

import XCTest
@testable import Flix

final class HomePresenterTests: XCTestCase {

    // MARK: - Properties
    private var sut: HomePresenter!
    private var viewController: HomeDisplayLogicSpy!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let presenter = HomePresenter()
        let viewController = HomeDisplayLogicSpy()

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
    func testPresentSceneTabs() {
        let response = HomeModels.InitialData.Response(sceneTabs: [SceneTab(option: .movies),
                                                                   SceneTab(option: .series),
                                                                   SceneTab(option: .tv)])
        sut.presentSceneTabs(response)

        XCTAssertTrue(viewController.isCalledDisplaySceneTabs, "Not started display scene tabs.")
    }

    func testPresentSceneTab() {
        let response = HomeModels.SceneTabData.Response(object: nil, sceneTab: SceneTab(option: .tv))
        sut.presentSceneTab(response)

        XCTAssertTrue(viewController.isCalledDisplaySceneTab, "Not started viewController display scene tab.")
    }

    func testFocusUpdateCompleted() {
        let response = HomeModels.FocusUpdateCompleted.Response(widthOfSceneTabsContainer: 100)
        sut.focusUpdateCompleted(response)

        XCTAssertTrue(viewController.isCalledFocusUpdateCompleted, "Not started display FocusUpdateCompleted.")
    }

    func testPresentSelectedHomeTab() {
        let response = HomeModels.SelectHomeTab.Response(sceneTab: SceneTab(option: .profile(image: nil)))
        sut.presentSelectedHomeTab(response)

        XCTAssertTrue(viewController.isCalledDisplaySelectedHomeTab, "Not started display DisplaySelectedHomeTab.")
    }

    func testPresentUpdatedTabs() {
        let response = HomeModels.UpdatedData.Response()
        sut.presentUpdatedTabs(response)

        XCTAssertTrue(viewController.isCalledDisplayUpdatedTabs, "Not started viewController display updated scene tabs.")
    }
}
