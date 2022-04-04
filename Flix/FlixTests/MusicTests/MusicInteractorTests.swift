//
//  MusicInteractorTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 16.11.2021.
//

import XCTest
@testable import Flix

final class MusicInteractorTests: XCTestCase {

    // MARK: - Properties
    private var sut: MusicInteractor!
    private var presenter: MusicPresentationLogicSpy!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let interactor = MusicInteractor()
        let presenter = MusicPresentationLogicSpy()

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
    func testFetchMusicCategories() {
        let request = MusicModels.InitialData.Request()
        sut.fetchMusicCategories(request)

        XCTAssertTrue(presenter.isCalledPresentSections, "Not started present music sections.")
    }

    func testFetchMusicItem() {
        sut.musicSections = createMusicSections()

        let firstSection = 0
        let numberOfItems = sut.musicSections[firstSection].items.count
        let request = MusicModels.MusicItemData.Request(object: nil, indexPath: IndexPath(item: numberOfItems - 1, section: firstSection))
        sut.fetchMusicItem(request)

        XCTAssertTrue(presenter.isCalledPresentMusicItem, "Not started present music item.")
    }

    func testFetchMusicSectionHeader() {
        sut.musicSections = createMusicSections()

        let firstSection = 0
        let numberOfItems = sut.musicSections[firstSection].items.count
        let request = MusicModels.MusicItemData.Request(object: nil, indexPath: IndexPath(item: numberOfItems - 1, section: firstSection))
        sut.fetchMusicSectionHeader(request)

        XCTAssertTrue(presenter.isCalledPresentMusicSectionHeader, "Not started present music section header.")
    }

    func testFetchMusicItemWithoutMusicSections() {
        let request = MusicModels.MusicItemData.Request(object: nil, indexPath: IndexPath(item: 0, section: 0))
        sut.fetchMusicItem(request)

        XCTAssertFalse(presenter.isCalledPresentMusicItem, "Should not start present music item.")
    }

    func testFetchMusicSectionHeaderWithoutMusicSections() {
        let request = MusicModels.MusicItemData.Request(object: nil, indexPath: IndexPath(item: 0, section: 0))
        sut.fetchMusicSectionHeader(request)

        XCTAssertFalse(presenter.isCalledPresentMusicSectionHeader, "Should not start present music section header.")
    }

    func testFocusChangedInMusicCollection() {
        let request = MusicModels.FocusChangedInMusicCollection.Request(nextIndexPath: IndexPath(item: 0, section: 0))
        sut.focusChangedInMusicCollection(request)

        XCTAssertTrue(presenter.isCalledFocusChangedInMusicCollection, "Not started present FocusChangedInMusicCollection.")
    }

    func testDidSelectSeries() {
        var selectedSeriesTitle = ""
        var selectedSeriesID: UUID?

        var section1 = [MusicItem]()
        var section2 = [MusicItem]()
        var section3 = [MusicItem]()
        var section4 = [MusicItem]()
        
        for _ in 0...Int.random(in: 1...10) {
            let item = MusicItem(poster: UIImage(named: "testMusic\(Int.random(in: 1...6))"),
                                 title: "One love",
                                 artist: "Elthon",
                                 album: "100 hits",
                                 tag: .pop)
            section1.append(item)
        }
        for i in 0...Int.random(in: 1...10) {
            let item = MusicItem(poster: UIImage(named: "testMusic\(Int.random(in: 1...6))"),
                                 title: "New wave",
                                 artist: "Gaga",
                                 album: "Esingle",
                                 tag: nil)
            if i == 1 {
                selectedSeriesTitle = item.title
                selectedSeriesID = item.id
            }
            section2.append(item)
        }
        for _ in 0...Int.random(in: 1...10) {
            let item = MusicItem(poster: UIImage(named: "testMusic\(Int.random(in: 1...6))"),
                                 title: "13",
                                 artist: "Drake",
                                 album: "Rap story",
                                 tag: nil)
            section3.append(item)
        }
        for _ in 0...Int.random(in: 1...10) {
            let item = MusicItem(poster: UIImage(named: "testMusic\(Int.random(in: 1...6))"),
                                 title: "Believe",
                                 artist: "Josh Groban",
                                 album: "Express",
                                 tag: .pop)
            section4.append(item)
        }
        sut.musicSections = [MusicSection(categoryTitle: "Section Music 1", items: section1),
                             MusicSection(categoryTitle: "Section Music 2", items: section2),
                             MusicSection(categoryTitle: "Section Music 3", items: section3),
                             MusicSection(categoryTitle: "Section Music 4", items: section4)]

        let request = MusicModels.SelectMusic.Request(indexPath: IndexPath(item: 1, section: 1))
        sut.didSelectMusic(request)

        XCTAssertEqual(sut.selectedMusic?.title, selectedSeriesTitle)
        XCTAssertEqual(sut.selectedMusic?.id, selectedSeriesID)
        XCTAssertTrue(presenter.isCalledPresentSelectedMusic, "Not started present selected music.")
    }

    func testDidSelectMusicFailed() {
        let request = MusicModels.SelectMusic.Request(indexPath: IndexPath(item: 1, section: 1))
        sut.didSelectMusic(request)

        XCTAssertFalse(presenter.isCalledPresentSelectedMusic, "Should not start present selected music.")
    }
}

// MARK: - Private methods
private extension MusicInteractorTests {
    func createMusicSections() -> [MusicSection] {
        var section1 = [MusicItem]()
        var section2 = [MusicItem]()
        var section3 = [MusicItem]()
        var section4 = [MusicItem]()
        
        for _ in 0...Int.random(in: 1...10) {
            let item = MusicItem(poster: UIImage(named: "testMusic\(Int.random(in: 1...6))"),
                                 title: "One love",
                                 artist: "Elthon",
                                 album: "100 hits",
                                 tag: .pop)
            section1.append(item)
        }
        for _ in 0...Int.random(in: 1...10) {
            let item = MusicItem(poster: UIImage(named: "testMusic\(Int.random(in: 1...6))"),
                                 title: "New wave",
                                 artist: "Gaga",
                                 album: "Esingle",
                                 tag: nil)
            section2.append(item)
        }
        for _ in 0...Int.random(in: 1...10) {
            let item = MusicItem(poster: UIImage(named: "testMusic\(Int.random(in: 1...6))"),
                                 title: "13",
                                 artist: "Drake",
                                 album: "Rap story",
                                 tag: nil)
            section3.append(item)
        }
        for _ in 0...Int.random(in: 1...10) {
            let item = MusicItem(poster: UIImage(named: "testMusic\(Int.random(in: 1...6))"),
                                 title: "Believe",
                                 artist: "Josh Groban",
                                 album: "Express",
                                 tag: .pop)
            section4.append(item)
        }
        let musicSections = [MusicSection(categoryTitle: "Section Music 1", items: section1),
                             MusicSection(categoryTitle: "Section Music 2", items: section2),
                             MusicSection(categoryTitle: "Section Music 3", items: section3),
                             MusicSection(categoryTitle: "Section Music 4", items: section4)]
        return musicSections
    }
}
