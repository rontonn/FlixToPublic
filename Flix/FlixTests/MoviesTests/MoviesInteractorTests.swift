//
//  MoviesInteractorTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 15.11.2021.
//

import XCTest
@testable import Flix

final class MoviesInteractorTests: XCTestCase {

    // MARK: - Properties
    private var sut: MoviesInteractor!
    private var presenter: MoviesPresentationLogicSpy!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let interactor = MoviesInteractor()
        let presenter = MoviesPresentationLogicSpy()

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
    func testFetchMoviesCategories() {
        let request = MoviesModels.InitialData.Request()
        sut.fetchMovieCategories(request)

        XCTAssertTrue(presenter.isCalledPresentSections, "Not started present movie sections.")
    }

    func testFetchMovie() {
        sut.movieSections = createMovieSections()

        let firstSection = 0
        let numberOfItems = sut.movieSections[firstSection].items.count
        let request = MoviesModels.MovieData.Request(object: nil,
                                                     indexPath: IndexPath(item: numberOfItems - 1, section: firstSection))
        sut.fetchMovie(request)

        XCTAssertTrue(presenter.isCalledPresentMovie, "Not started present movie.")
    }

    func testFetchMovieSectionHeader() {
        sut.movieSections = createMovieSections()

        let firstSection = 0
        let numberOfItems = sut.movieSections[firstSection].items.count
        let request = MoviesModels.MovieData.Request(object: nil, indexPath: IndexPath(item: numberOfItems - 1, section: firstSection))
        sut.fetchMovieSectionHeader(request)

        XCTAssertTrue(presenter.isCalledPresentMovieSectionHeader, "Not started present movie section header.")
    }

    func testFetchMovieWithoutMovieSections() {
        let request = MoviesModels.MovieData.Request(object: nil, indexPath: IndexPath(item: 0, section: 0))
        sut.fetchMovie(request)

        XCTAssertFalse(presenter.isCalledPresentMovie, "Should not start present movie.")
    }

    func testFetchMovieSectionHeaderWithoutMovieSections() {
        let request = MoviesModels.MovieData.Request(object: nil, indexPath: IndexPath(item: 0, section: 0))
        sut.fetchMovieSectionHeader(request)

        XCTAssertFalse(presenter.isCalledPresentMovieSectionHeader, "Should not start present movie section header.")
    }

    func testFocusChangedInMoviesCollection() {
        let request = MoviesModels.FocusChangedInMoviesCollection.Request(nextIndexPath: IndexPath(item: 0, section: 0))
        sut.focusChangedInMoviesCollection(request)

        XCTAssertTrue(presenter.isCalledFocusChangedInMoviesCollection, "Not started present FocusChangedInMoviesCollection.")
    }

    func testDidSelectMovie() {
        var section1 = [VideoOnDemandItem]()
        var section2 = [VideoOnDemandItem]()
        var section3 = [VideoOnDemandItem]()
        var section4 = [VideoOnDemandItem]()

        var selectedMovieTitle = ""
        var selectedMovieID: UUID?
        for _ in 0...Int.random(in: 1...10) {
            let item = VideoOnDemandItem(poster: nil,
                                         title: "item \(Int.random(in: 1...100))",
                                         ratingOwner: "",
                                         ratingValue: 0,
                                         tag: nil)
            section1.append(item)
        }
        for i in 0...Int.random(in: 1...10) {
            let item = VideoOnDemandItem(poster: nil,
                                         title: "item \(Int.random(in: 1...100))",
                                         ratingOwner: "",
                                         ratingValue: 0,
                                         tag: nil)
            if i == 1 {
                selectedMovieID = item.id
                selectedMovieTitle = item.title
            }
            section2.append(item)
        }
        for _ in 0...Int.random(in: 1...10) {
            let item = VideoOnDemandItem(poster: nil,
                                         title: "item \(Int.random(in: 1...100))",
                                         ratingOwner: "",
                                         ratingValue: 0,
                                         tag: nil)
            section3.append(item)
        }
        for _ in 0...Int.random(in: 1...10) {
            let item = VideoOnDemandItem(poster: nil,
                                         title: "item \(Int.random(in: 1...100))",
                                         ratingOwner: "",
                                         ratingValue: 0,
                                         tag: nil)
            section4.append(item)
        }
        sut.movieSections = [VideoOnDemandSection(categoryTitle: "", items: section1, type: .movie),
                             VideoOnDemandSection(categoryTitle: "", items: section2, type: .movie),
                             VideoOnDemandSection(categoryTitle: "", items: section3, type: .movie),
                             VideoOnDemandSection(categoryTitle: "", items: section4, type: .movie)]

        let request = MoviesModels.SelectMovie.Request(indexPath: IndexPath(item: 1, section: 1))
        sut.didSelectMovie(request)

        XCTAssertEqual(sut.selectedMovie?.title, selectedMovieTitle)
        XCTAssertEqual(sut.selectedMovie?.id, selectedMovieID)
        XCTAssertTrue(presenter.isCalledPresentSelectedMovie, "Not started present selected movie.")
    }

    func testDidSelectMovieFailed() {
        let request = MoviesModels.SelectMovie.Request(indexPath: IndexPath(item: 1, section: 1))
        sut.didSelectMovie(request)

        XCTAssertFalse(presenter.isCalledPresentSelectedMovie, "Should not started present selected movie.")
    }
}

// MARK: - Private methods
private extension MoviesInteractorTests {
    func createMovieSections() -> [VideoOnDemandSection] {
        var section1 = [VideoOnDemandItem]()
        var section2 = [VideoOnDemandItem]()
        var section3 = [VideoOnDemandItem]()
        var section4 = [VideoOnDemandItem]()

        for _ in 0...Int.random(in: 1...10) {
            let item = VideoOnDemandItem(poster: nil,
                                         title: "item \(Int.random(in: 1...100))",
                                         ratingOwner: "",
                                         ratingValue: 0,
                                         tag: nil)
            section1.append(item)
        }
        for _ in 0...Int.random(in: 1...10) {
            let item = VideoOnDemandItem(poster: nil,
                                         title: "item \(Int.random(in: 1...100))",
                                         ratingOwner: "",
                                         ratingValue: 0,
                                         tag: nil)
            section2.append(item)
        }
        for _ in 0...Int.random(in: 1...10) {
            let item = VideoOnDemandItem(poster: nil,
                                         title: "item \(Int.random(in: 1...100))",
                                         ratingOwner: "",
                                         ratingValue: 0,
                                         tag: nil)
            section3.append(item)
        }
        for _ in 0...Int.random(in: 1...10) {
            let item = VideoOnDemandItem(poster: nil,
                                         title: "item \(Int.random(in: 1...100))",
                                         ratingOwner: "",
                                         ratingValue: 0,
                                         tag: nil)
            section4.append(item)
        }
        let movieSections = [VideoOnDemandSection(categoryTitle: "", items: section1, type: .movie),
                             VideoOnDemandSection(categoryTitle: "", items: section2, type: .movie),
                             VideoOnDemandSection(categoryTitle: "", items: section3, type: .movie),
                             VideoOnDemandSection(categoryTitle: "", items: section4, type: .movie)]
        return movieSections
    }
}
