//
//  
//  MusicPresenter.swift
//  Flix
//
//  Created by Anton Romanov on 15.10.2021.
//
//

import UIKit

protocol MusicPresentationLogic {
    func presentMusicSections(_ response: MusicModels.InitialData.Response)
    func presentMusicItem(_ response: MusicModels.MusicItemData.Response)
    func presentMusicSectionHeader(_ response: MusicModels.MusicItemData.Response)
    func focusChangedInMusicCollection(_ response: MusicModels.FocusChangedInMusicCollection.Response)
    func presentSelectedMusic(_ response: MusicModels.SelectMusic.Response)
}

final class MusicPresenter {
    // MARK: - Properties
    weak var viewController: MusicDisplayLogic?

    private let numberOfItemsInRow: CGFloat = 4
    private let leadingPaddingOfMusicCollectionByDefault: CGFloat = 200
    private let leadingPaddingOfMusicCollectionExpanded: CGFloat = 50
}

extension MusicPresenter: MusicPresentationLogic {
    func presentMusicSections(_ response: MusicModels.InitialData.Response) {
        let musicCollectionLayoutSource = MusicCollectionLayoutSource(numberOfItemsInRow: numberOfItemsInRow)
        let layout = musicCollectionLayoutSource.createLayout()

        let snapshot = dataSourceSnapshotFor(response.musicSections)
        let viewModel = MusicModels.InitialData.ViewModel(dataSourceSnapshot: snapshot,
                                                          layout: layout,
                                                          leadingPadding: leadingPaddingOfMusicCollectionByDefault)
        viewController?.displayMusicSections(viewModel)
    }

    func presentMusicItem(_ response: MusicModels.MusicItemData.Response) {
        let viewModel = MusicModels.MusicItemData.ViewModel(object: response.object, categoryTile: response.categoryTile, musicItem: response.musicItem)
        viewController?.displayMusicItem(viewModel)
    }

    func presentMusicSectionHeader(_ response: MusicModels.MusicItemData.Response) {
        let viewModel = MusicModels.MusicItemData.ViewModel(object: response.object, categoryTile: response.categoryTile, musicItem: response.musicItem)
        viewController?.displayMusicSectionHeader(viewModel)
    }

    func focusChangedInMusicCollection(_ response: MusicModels.FocusChangedInMusicCollection.Response) {
        guard numberOfItemsInRow != 0 else {
            return
        }
        
        let afterNextPosition = response.nextIndexPathItem + 1
        let itemPosition = CGFloat(afterNextPosition)

        notifyHomeSceneAboutSideBarPositionIfNeededFor(itemPosition)
        setMusicCollectionPositionIfNeededFor(itemPosition)
    }

    func presentSelectedMusic(_ response: MusicModels.SelectMusic.Response) {
        let viewModel = MusicModels.SelectMusic.ViewModel()
        viewController?.displaySelectedMusic(viewModel)
    }
}

// MARK: - Private methods {
private extension MusicPresenter {
    func notifyHomeSceneAboutSideBarPositionIfNeededFor(_ itemPosition: CGFloat) {
        let viewModel = MusicModels.FocusChangedInMusicCollection.ViewModel(leadingPadding: nil)
        if itemPosition >= numberOfItemsInRow {
            viewController?.notifyHomeSceneToHideSidebar(viewModel)

        } else if itemPosition == 1 {
            viewController?.notifyHomeSceneToShowSidebar(viewModel)
        }
    }

    func setMusicCollectionPositionIfNeededFor(_ itemPosition: CGFloat) {
        var leadingPadding: CGFloat?

        if itemPosition >= numberOfItemsInRow {
            leadingPadding = leadingPaddingOfMusicCollectionExpanded

        } else if itemPosition == 1 {
            leadingPadding = leadingPaddingOfMusicCollectionByDefault

        }
        let viewModel = MusicModels.FocusChangedInMusicCollection.ViewModel(leadingPadding: leadingPadding)
        viewController?.setMusicCollectionPosition(viewModel)
    }

    func dataSourceSnapshotFor(_ musicSections: [MusicSection]) -> NSDiffableDataSourceSnapshot<UUID, UUID> {
        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        musicSections.forEach {
            snapshot.appendSections([$0.id])
            let uuids: [UUID] = $0.items.map{ $0.id }
            snapshot.appendItems(uuids, toSection: $0.id)
        }
        return snapshot
    }
}
