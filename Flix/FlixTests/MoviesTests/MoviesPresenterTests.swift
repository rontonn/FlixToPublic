//
//  MoviesPresenterTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 15.11.2021.
//

import XCTest
@testable import Flix

final class MoviesPresenterTests: XCTestCase {

    // MARK: - Properties
    private var sut: MoviesPresenter!
    private var viewController: MoviesDisplayLogicSpy!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let presenter = MoviesPresenter()
        let viewController = MoviesDisplayLogicSpy()

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
    func testPresentMoviesCategories() {
        let response = MoviesModels.InitialData.Response(movieSections: [])
        sut.presentSections(response)

        XCTAssertTrue(viewController.isCalledDisplayMovieSecitons, "Not started viewController display movie sections.")
    }
    
    func testPresentMovie() {
        let movie = VideoOnDemandItem(poster: nil, title: "", ratingOwner: "", ratingValue: 0, tag: nil)
        let response = MoviesModels.MovieData.Response(object: nil, categoryTile: nil, movie: movie)
        sut.presentMovie(response)

        XCTAssertTrue(viewController.isCalledDisplayMovie, "Not started viewController display movie.")
    }

    func testPresentMovieSectionHeader() {
        let response = MoviesModels.MovieData.Response(object: nil, categoryTile: "", movie: nil)
        sut.presentMovieSectionHeader(response)

        XCTAssertTrue(viewController.isCalledDisplayMovieSectionHeader, "Not started viewController display movie section header.")
    }

    func testPresentSelectedMovie() {
        let response = MoviesModels.SelectMovie.Response()
        sut.presentSelectedMovie(response)

        XCTAssertTrue(viewController.isCalledDisplaySelectedMovie, "Not started viewController display selected movie.")
    }

    func testFocusChangedInMoviesCollectionToItemBeyoyndRightScreenEdgde() {
        let response = MoviesModels.FocusChangedInMoviesCollection.Response(nextIndexPathItem: 6)
        sut.focusChangedInMoviesCollection(response)

        XCTAssertFalse(viewController.isCalledNotifyHomeSceneToShowSidebar, "Should not start viewController NotifyHomeSceneToShowSidebar.")
        XCTAssertTrue(viewController.isCalledNotifyHomeSceneToHideSidebar, "Not started viewController NotifyHomeSceneToHideSidebar.")
        XCTAssertTrue(viewController.isCalledSetMoviesCollectionPosition, "Not started viewController SetMoviesCollectionPosition.")
    }

    func testFocusChangedInMoviesCollectionToTheFirstItem() {
        let response = MoviesModels.FocusChangedInMoviesCollection.Response(nextIndexPathItem: 0)
        sut.focusChangedInMoviesCollection(response)

        XCTAssertTrue(viewController.isCalledNotifyHomeSceneToShowSidebar, "Not started viewController NotifyHomeSceneToShowSidebar.")
        XCTAssertFalse(viewController.isCalledNotifyHomeSceneToHideSidebar, "Should not start viewController NotifyHomeSceneToHideSidebar.")
        XCTAssertTrue(viewController.isCalledSetMoviesCollectionPosition, "Not started viewController SetMoviesCollectionPosition.")
    }

    func testFocusChangedInMoviesCollection() {
        let response = MoviesModels.FocusChangedInMoviesCollection.Response(nextIndexPathItem: 2)
        sut.focusChangedInMoviesCollection(response)

        XCTAssertFalse(viewController.isCalledNotifyHomeSceneToShowSidebar, "Should not start viewController NotifyHomeSceneToShowSidebar.")
        XCTAssertFalse(viewController.isCalledNotifyHomeSceneToHideSidebar, "Should not start viewController NotifyHomeSceneToHideSidebar.")
        XCTAssertTrue(viewController.isCalledSetMoviesCollectionPosition, "Not started viewController SetMoviesCollectionPosition.")
    }
}
