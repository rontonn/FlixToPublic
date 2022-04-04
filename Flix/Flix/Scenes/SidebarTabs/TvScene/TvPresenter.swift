//
//  
//  TvPresenter.swift
//  Flix
//
//  Created by Anton Romanov on 15.10.2021.
//
//

import UIKit

protocol TvPresentationLogic {
    func presentTvSections(_ response: TvModels.InitialData.Response)
    func presentTvBroadcastsHeaderItem(_ response: TvModels.TvItemData.Response)
    func presentTvBroadcastsItem(_ response: TvModels.TvItemData.Response)
    func presentTvChannelsHeaderItem(_ response: TvModels.TvItemData.Response)
    func presentTvChannelsItem(_ response: TvModels.TvItemData.Response)
    func focusChangedInTvCollection(_ response: TvModels.FocusChangedInTvCollection.Response)
    func presentSelectedTvItem(_ response: TvModels.SelectTvItem.Response)
}

final class TvPresenter {
    // MARK: - Properties
    weak var viewController: TvDisplayLogic?

    private let leadingPaddingOfTvCollectionByDefault: CGFloat = 200
    private let leadingPaddingOfTvCollectionExpanded: CGFloat = 50
}

extension TvPresenter: TvPresentationLogic {
    func presentTvSections(_ response: TvModels.InitialData.Response) {
        let tvCollectionLayoutSource = TvCollectionLayoutSource(sections: response.sections)
        let layout = tvCollectionLayoutSource.createLayout()

        let snapshot = dataSourceSnapshotFor(response.sections)
        let viewModel = TvModels.InitialData.ViewModel(dataSourceSnapshot: snapshot,
                                                       layout: layout,
                                                       leadingPadding: leadingPaddingOfTvCollectionByDefault)
        viewController?.displayTvSections(viewModel)
    }

    func presentTvBroadcastsHeaderItem(_ response: TvModels.TvItemData.Response) {
        guard case .trendingLiveBroadcasts(let tvBroadcasts) = response.tvSection else {
            return
        }
        let viewModel = TvModels.TvItemData.ViewModel(object: response.object,
                                                      categoryTile: nil,
                                                      tvBroadcastsSectionHeader: tvBroadcasts.header,
                                                      tvBroadcastItem: nil,
                                                      tvChannelItem: nil)
        viewController?.displayTvBroadcastsHeaderItem(viewModel)
    }

    func presentTvBroadcastsItem(_ response: TvModels.TvItemData.Response) {
        guard case .trendingLiveBroadcasts(let tvBroadcasts) = response.tvSection,
              let tvBroadcastItem = tvBroadcasts.items[safe: response.indexPath.item] else {
            return
        }
        let viewModel = TvModels.TvItemData.ViewModel(object: response.object,
                                                      categoryTile: nil,
                                                      tvBroadcastsSectionHeader: nil,
                                                      tvBroadcastItem: tvBroadcastItem,
                                                      tvChannelItem: nil)
        viewController?.displayTvBroadcastsItem(viewModel)
    }

    func presentTvChannelsHeaderItem(_ response: TvModels.TvItemData.Response) {
        guard case .trendingChannels(let channels) = response.tvSection else {
            return
        }
        let viewModel = TvModels.TvItemData.ViewModel(object: response.object,
                                                      categoryTile: channels.categoryTitle,
                                                      tvBroadcastsSectionHeader: nil,
                                                      tvBroadcastItem: nil,
                                                      tvChannelItem: nil)
        viewController?.displayTvChannelsHeaderItem(viewModel)
    }

    func presentTvChannelsItem(_ response: TvModels.TvItemData.Response) {
        guard case .trendingChannels(let channels) = response.tvSection,
        let tvChannelItem = channels.items[safe: response.indexPath.item] else {
            return
        }
        let viewModel = TvModels.TvItemData.ViewModel(object: response.object,
                                                      categoryTile: nil,
                                                      tvBroadcastsSectionHeader: nil,
                                                      tvBroadcastItem: nil,
                                                      tvChannelItem: tvChannelItem)
        viewController?.displayTvChannelsItem(viewModel)
    }

    func focusChangedInTvCollection(_ response: TvModels.FocusChangedInTvCollection.Response) {
        let numberOfItemsInRow = response.tvSection.numberOfItemsInRow
        guard numberOfItemsInRow != 0 else {
            return
        }
        
        let afterNextPosition = response.nextIndexPathItem + 1
        let itemPosition = CGFloat(afterNextPosition)

        notifyHomeSceneAboutSideBarPositionIfNeededFor(itemPosition, numberOfItemsInRow: numberOfItemsInRow.rounded(.down))
        setTvCollectionPositionIfNeededFor(itemPosition, numberOfItemsInRow: numberOfItemsInRow.rounded(.down))
    }

    func presentSelectedTvItem(_ response: TvModels.SelectTvItem.Response) {
        let viewModel = TvModels.SelectTvItem.ViewModel()
        viewController?.displaySelectedTvItem(viewModel)
    }
}

// MARK: - Private methods {
private extension TvPresenter {
    func notifyHomeSceneAboutSideBarPositionIfNeededFor(_ itemPosition: CGFloat, numberOfItemsInRow: CGFloat) {
        let viewModel = TvModels.FocusChangedInTvCollection.ViewModel(leadingPadding: nil)
        if itemPosition >= numberOfItemsInRow {
            viewController?.notifyHomeSceneToHideSidebar(viewModel)

        } else if itemPosition == 1 {
            viewController?.notifyHomeSceneToShowSidebar(viewModel)
        }
    }

    func setTvCollectionPositionIfNeededFor(_ itemPosition: CGFloat, numberOfItemsInRow: CGFloat) {
        var leadingPadding: CGFloat?

        if itemPosition >= numberOfItemsInRow {
            leadingPadding = leadingPaddingOfTvCollectionExpanded

        } else if itemPosition == 1 {
            leadingPadding = leadingPaddingOfTvCollectionByDefault

        }
        let viewModel = TvModels.FocusChangedInTvCollection.ViewModel(leadingPadding: leadingPadding)
        viewController?.setTvCollectionPosition(viewModel)
    }

    func dataSourceSnapshotFor(_ tvSections: [TvModels.Section]) -> NSDiffableDataSourceSnapshot<UUID, UUID> {

        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        tvSections.forEach { tvSection in
            switch tvSection {
            case .trendingChannels(let channels):
                snapshot.appendSections([channels.id])
                let uuids: [UUID] = channels.items.map{ $0.id }
                snapshot.appendItems(uuids)
            case .trendingLiveBroadcasts(let broadcasts):
                snapshot.appendSections([broadcasts.id])
                let uuids: [UUID] = broadcasts.items.map{ $0.id }
                snapshot.appendItems(uuids)
            }
        }

        return snapshot
    }
}
