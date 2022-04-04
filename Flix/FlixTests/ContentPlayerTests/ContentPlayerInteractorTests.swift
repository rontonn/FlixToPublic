//
//  ContentPlayerInteractorTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 19.11.2021.
//

import XCTest
@testable import Flix

final class ContentPlayerInteractorTests: XCTestCase {

    // MARK: - Properties
    private var sut: ContentPlayerInteractor!
    private var presenter: ContentPlayerPresentationLogicSpy!
    private var masterPlaylistWorker: MasterPlaylistWorkerLogicSpy!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let interactor = ContentPlayerInteractor()
        let presenter = ContentPlayerPresentationLogicSpy()
        let masterPlaylistWorker = MasterPlaylistWorkerLogicSpy()

        interactor.presenter = presenter
        interactor.masterPlaylistWorker = masterPlaylistWorker

        sut = interactor
        self.presenter = presenter
        self.masterPlaylistWorker = masterPlaylistWorker
    }

    override func tearDown() {
        sut = nil
        presenter = nil
        masterPlaylistWorker = nil

        super.tearDown()
    }

    // MARK: - Public Methods
    func testFetchURLToPlay() async {
        let request = ContentPlayerModels.InitialData.Request()
        await sut.fetchURLToPlay(request)

        XCTAssertTrue(presenter.isCalledPresentContent, "Not started present content.")
        XCTAssertTrue(masterPlaylistWorker.isCalledGetMasterPlaylist, "Not started masterPlaylistWorker.getMasterPlaylist.")
        XCTAssertTrue(masterPlaylistWorker.isCalledGetMasterPlaylistWithFakeKeyURLs, "Not started masterPlaylistWorker.getMasterPlaylistWithFakeKeyURLs.")
    }
}
