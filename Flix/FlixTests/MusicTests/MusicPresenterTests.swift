//
//  MusicPresenterTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 16.11.2021.
//

import XCTest
@testable import Flix

final class MusicPresenterTests: XCTestCase {

    // MARK: - Properties
    private var sut: MusicPresenter!
    private var viewController: MusicDisplayLogicSpy!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let presenter = MusicPresenter()
        let viewController = MusicDisplayLogicSpy()

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
    func testPresentMusicCategories() {
        let response = MusicModels.InitialData.Response(musicSections: [])
        sut.presentMusicSections(response)

        XCTAssertTrue(viewController.isCalledDisplayMusicSecitons, "Not started viewController display msuic sections.")
    }

    func testPresentMusicItem() {
        let musicItem = MusicItem(poster: nil, title: "", artist: "", album: "", tag: nil)
        let response = MusicModels.MusicItemData.Response(object: nil, categoryTile: nil, musicItem: musicItem)
        sut.presentMusicItem(response)

        XCTAssertTrue(viewController.isCalledDisplayMusicItem, "Not started viewController display msuic item.")
    }

    func testPresentMusicSectionHeader() {
        let response = MusicModels.MusicItemData.Response(object: nil, categoryTile: "", musicItem: nil)
        sut.presentMusicSectionHeader(response)

        XCTAssertTrue(viewController.isCalledDisplayMusicSectionHeader, "Not started viewController display msuic section header.")
    }

    func testPresentSelectedMusic() {
        let response = MusicModels.SelectMusic.Response()
        sut.presentSelectedMusic(response)

        XCTAssertTrue(viewController.isCalledDisplaySelectedMusic, "Not started viewController display selected music.")
    }

    func testFocusChangedInMusicCollectionToItemBeyoyndRightScreenEdgde() {
        let response = MusicModels.FocusChangedInMusicCollection.Response(nextIndexPathItem: 6)
        sut.focusChangedInMusicCollection(response)

        XCTAssertFalse(viewController.isCalledNotifyHomeSceneToShowSidebar, "Should not start viewController NotifyHomeSceneToShowSidebar.")
        XCTAssertTrue(viewController.isCalledNotifyHomeSceneToHideSidebar, "Not started viewController NotifyHomeSceneToHideSidebar.")
        XCTAssertTrue(viewController.isCalledSetMusicCollectionPosition, "Not started viewController SetMusicCollectionPosition.")
    }

    func testFocusChangedInMusicCollectionToTheFirstItem() {
        let response = MusicModels.FocusChangedInMusicCollection.Response(nextIndexPathItem: 0)
        sut.focusChangedInMusicCollection(response)

        XCTAssertTrue(viewController.isCalledNotifyHomeSceneToShowSidebar, "Not started viewController NotifyHomeSceneToShowSidebar.")
        XCTAssertFalse(viewController.isCalledNotifyHomeSceneToHideSidebar, "Should not start viewController NotifyHomeSceneToHideSidebar.")
        XCTAssertTrue(viewController.isCalledSetMusicCollectionPosition, "Not started viewController SetMusicCollectionPosition.")
    }

    func testFocusChangedInMusicCollection() {
        let response = MusicModels.FocusChangedInMusicCollection.Response(nextIndexPathItem: 2)
        sut.focusChangedInMusicCollection(response)

        XCTAssertFalse(viewController.isCalledNotifyHomeSceneToShowSidebar, "Should not start viewController NotifyHomeSceneToShowSidebar.")
        XCTAssertFalse(viewController.isCalledNotifyHomeSceneToHideSidebar, "Should not start viewController NotifyHomeSceneToHideSidebar.")
        XCTAssertTrue(viewController.isCalledSetMusicCollectionPosition, "Not started viewController SetMusicCollectionPosition.")
    }
}
