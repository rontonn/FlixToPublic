//
//  HomeInteractorTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 15.11.2021.
//

import XCTest
@testable import Flix

final class HomeInteractorTests: XCTestCase {

    // MARK: - Properties
    private var sut: HomeInteractor!
    private var presenter: HomePresentationLogicSpy!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let interactor = HomeInteractor()
        let presenter = HomePresentationLogicSpy()

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
    func testRequestSceneTabs() {
        let request = HomeModels.InitialData.Request()
        sut.provideSceneTabs(request)

        XCTAssertTrue(presenter.isCalledPresentSceneTabs, "Not started present scene tabs.")
    }

    func testFetchSceneTab() {
        sut.sceneTabs = [SceneTab(option: .profile(image: nil)),
                         SceneTab(option: .series),
                         SceneTab(option: .movies),
                         SceneTab(option: .music),
                         SceneTab(option: .tv)]

        let numberOfItems = sut.sceneTabs.count
        let request = HomeModels.SceneTabData.Request(object: nil,
                                                      indexPath: IndexPath(item: numberOfItems - 1, section: 0))
        sut.fetchSceneTab(request)

        XCTAssertTrue(presenter.isCalledPresentSceneTab, "Not started present scene tab.")
    }

    func testFetchSceneTabWithoutTabs() {
        let request = HomeModels.SceneTabData.Request(object: nil,
                                                      indexPath: IndexPath(item: 0, section: 0))
        sut.fetchSceneTab(request)

        XCTAssertFalse(presenter.isCalledPresentSceneTab, "Should not start present scene tab.")
    }

    func testRequestFocusUpdateCompletedToSceneTab() {
        let request = HomeModels.FocusUpdateCompleted.Request(currentWidthOfSceneTabsContainer: 321,
                                                              toSceneTab: true)
        sut.focusUpdateCompleted(request)
        XCTAssertTrue(presenter.isCalledFocusUpdateCompleted, "Not started present FocusUpdateCompletedToSceneTab.")
    }

    func testRequestFocusUpdateCompletedToTheSameSceneTab() {
        let request = HomeModels.FocusUpdateCompleted.Request(currentWidthOfSceneTabsContainer: 308,
                                                              toSceneTab: true)
        sut.focusUpdateCompleted(request)
        XCTAssertFalse(presenter.isCalledFocusUpdateCompleted, "Should not start present FocusUpdateCompletedToSceneTab.")
    }

    func testRequestFocusUpdateCompletedToOtherItem() {
        let request = HomeModels.FocusUpdateCompleted.Request(currentWidthOfSceneTabsContainer: 123,
                                                              toSceneTab: false)
        sut.focusUpdateCompleted(request)
        XCTAssertTrue(presenter.isCalledFocusUpdateCompleted, "Not started present FocusUpdateCompletedToOtherItem.")
    }

    func testRequestFocusUpdateCompletedToTheSameOtherItem() {
        let request = HomeModels.FocusUpdateCompleted.Request(currentWidthOfSceneTabsContainer: 98,
                                                              toSceneTab: false)
        sut.focusUpdateCompleted(request)
        XCTAssertFalse(presenter.isCalledFocusUpdateCompleted, "Should not start present FocusUpdateCompletedToOtherItem.")
    }

    func testRequestDidSelectHomeTab() {
        sut.sceneTabs = [SceneTab(option: .profile(image: nil)),
                         SceneTab(option: .series),
                         SceneTab(option: .movies),
                         SceneTab(option: .music),
                         SceneTab(option: .tv)]
        let numberOfHomeTabs = sut.sceneTabs.count
        let request = HomeModels.SelectHomeTab.Request(indexPath: IndexPath(item: numberOfHomeTabs - 1, section: 0))
        sut.didSelectHomeTab(request)

        XCTAssertTrue(presenter.isCalledPresentSelectedHomeTab, "Not started present PresentSelectedHomeTab.")
    }

    func testRequestDidSelectHomeTabWithoutHomeTabs() {
        let request = HomeModels.SelectHomeTab.Request(indexPath: IndexPath(item: 0, section: 0))
        sut.didSelectHomeTab(request)

        XCTAssertFalse(presenter.isCalledPresentSelectedHomeTab, "Should not start present PresentSelectedHomeTab.")
    }

    func testFetchUpdatedTabs() {
        let request = HomeModels.UpdatedData.Request()
        sut.fetchUpdatedTabs(request)

        XCTAssertTrue(presenter.isCalledPresentUpdatedTabs, "Not started present updated scene tabs.")
    }
}
