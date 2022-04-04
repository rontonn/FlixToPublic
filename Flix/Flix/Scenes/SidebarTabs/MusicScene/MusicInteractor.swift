//
//  
//  MusicInteractor.swift
//  Flix
//
//  Created by Anton Romanov on 15.10.2021.
//
//

import UIKit

protocol MusicBusinessLogic {
    func fetchMusicCategories(_ request: MusicModels.InitialData.Request)
    func fetchMusicItem(_ request: MusicModels.MusicItemData.Request)
    func fetchMusicSectionHeader(_ request: MusicModels.MusicItemData.Request)
    func focusChangedInMusicCollection(_ request: MusicModels.FocusChangedInMusicCollection.Request)
    func didSelectMusic(_ request: MusicModels.SelectMusic.Request)
}

protocol MusicDataStore {
    var selectedMusic: MusicItem? { get }
    var musicSections: [MusicSection] { get }
}

final class MusicInteractor: MusicDataStore {
    // MARK: - Properties
    var presenter: MusicPresentationLogic?
    var selectedMusic: MusicItem?
    var musicSections: [MusicSection] = []
}

extension MusicInteractor: MusicBusinessLogic {
    func fetchMusicCategories(_ request: MusicModels.InitialData.Request) {
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
        musicSections = [MusicSection(categoryTitle: "Section Music 1", items: section1),
                         MusicSection(categoryTitle: "Section Music 2", items: section2),
                         MusicSection(categoryTitle: "Section Music 3", items: section3),
                         MusicSection(categoryTitle: "Section Music 4", items: section4)]
        let response = MusicModels.InitialData.Response(musicSections: musicSections)

        presenter?.presentMusicSections(response)
    }

    func fetchMusicItem(_ request: MusicModels.MusicItemData.Request) {
        guard let musicSection = musicSections[safe: request.indexPath.section],
              let musicItem = musicSection.items[safe: request.indexPath.item] else {
            return
        }
        let response = MusicModels.MusicItemData.Response(object: request.object, categoryTile: nil, musicItem: musicItem)
        presenter?.presentMusicItem(response)
    }

    func fetchMusicSectionHeader(_ request: MusicModels.MusicItemData.Request) {
        guard let musicSection = musicSections[safe: request.indexPath.section] else {
            return
        }
        let response = MusicModels.MusicItemData.Response(object: request.object, categoryTile: musicSection.categoryTitle, musicItem: nil)
        presenter?.presentMusicSectionHeader(response)
    }

    func focusChangedInMusicCollection(_ request: MusicModels.FocusChangedInMusicCollection.Request) {
        let response = MusicModels.FocusChangedInMusicCollection.Response(nextIndexPathItem: request.nextIndexPath.item)
        presenter?.focusChangedInMusicCollection(response)
    }

    func didSelectMusic(_ request: MusicModels.SelectMusic.Request) {
        guard let musicSection = musicSections[safe: request.indexPath.section],
              let selectedMusic = musicSection.items[safe: request.indexPath.item] else {
            return
        }
        self.selectedMusic = selectedMusic
        let response = MusicModels.SelectMusic.Response()
        presenter?.presentSelectedMusic(response)
    }
}
