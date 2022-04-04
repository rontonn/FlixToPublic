//
//  
//  TvInteractor.swift
//  Flix
//
//  Created by Anton Romanov on 15.10.2021.
//
//

import UIKit

protocol TvBusinessLogic {
    func fetchTvCategories(_ request: TvModels.InitialData.Request)
    func fetchTvBroadcastsHeaderItem(_ request: TvModels.TvItemData.Request)
    func fetchTvBroadcastsItem(_ request: TvModels.TvItemData.Request)
    func fetchTvChannelsHeaderItem(_ request: TvModels.TvItemData.Request)
    func fetchTvChannelsItem(_ request: TvModels.TvItemData.Request)
    func focusChangedInTvCollection(_ request: TvModels.FocusChangedInTvCollection.Request)
    func didSelectTvItem(_ request: TvModels.SelectTvItem.Request)
}

protocol TvDataStore {
    var tvSections: [TvModels.Section] { get }
    var selectedTvBroadcastItem: TvBroadcastItem? { get }
    var selectedTvChannelItem: TvChannelItem? { get }
}

final class TvInteractor: TvDataStore {
    // MARK: - Properties
    var presenter: TvPresentationLogic?
    var tvSections: [TvModels.Section] = []
    var selectedTvBroadcastItem: TvBroadcastItem?
    var selectedTvChannelItem: TvChannelItem?
}

extension TvInteractor: TvBusinessLogic {
    func fetchTvCategories(_ request: TvModels.InitialData.Request) {
        var section1 = [TvBroadcastItem]()
        let section2 = [TvChannelItem(category: .flixLive),
                        TvChannelItem(category: .crypto),
                        TvChannelItem(category: .crypto),
                        TvChannelItem(category: .daily),
                        TvChannelItem(category: .flixLive),
                        TvChannelItem(category: .daily),
                        TvChannelItem(category: .crypto)]
        
        for i in 0...Int.random(in: 1...10) {
            let item = TvBroadcastItem(poster: UIImage(named: "testTV\(Int.random(in: 1...3))"),
                                       title: "Broadcast \(i)",
                                       subtitle: "Subtitle broadcast \(i)\(i)",
                                       description: "asdfkjsdbnkjasns ksdn vjs,nd vjs dkv.sn v,s dnv,sm dnv .s dmv m,dsf v", tag: .live)
            section1.append(item)
        }

        let tvBroadcastsHeader = TvBroadcastsSection.Header(tag: "Featured stream",
                                                            stream: "Super duper stream.",
                                                            categories: "Technology | News",
                                                            title: "Trending Live Broadcasts")
        let tvBroadcasts = TvBroadcastsSection(header: tvBroadcastsHeader,
                                                      items: section1)
        let tvChannels = TvChannelsSection(categoryTitle: "Trending Channels", items: section2)

        let tvBroadcastsSection = TvModels.Section.trendingLiveBroadcasts(broadcasts: tvBroadcasts)
        let tvChannelsSection = TvModels.Section.trendingChannels(channels: tvChannels)

        tvSections = [tvBroadcastsSection, tvChannelsSection]
        let response = TvModels.InitialData.Response(sections: tvSections)
        presenter?.presentTvSections(response)
    }

    func fetchTvBroadcastsHeaderItem(_ request: TvModels.TvItemData.Request) {
        guard let tvSection = tvSections[safe: request.indexPath.section] else {
            return
        }
        let response = TvModels.TvItemData.Response(object: request.object,
                                                    indexPath: request.indexPath,
                                                    tvSection: tvSection)
        presenter?.presentTvBroadcastsHeaderItem(response)
    }

    func fetchTvBroadcastsItem(_ request: TvModels.TvItemData.Request) {
        guard let tvSection = tvSections[safe: request.indexPath.section] else {
            return
        }
        let response = TvModels.TvItemData.Response(object: request.object,
                                                    indexPath: request.indexPath,
                                                    tvSection: tvSection)
        presenter?.presentTvBroadcastsItem(response)
    }

    func fetchTvChannelsHeaderItem(_ request: TvModels.TvItemData.Request) {
        guard let tvSection = tvSections[safe: request.indexPath.section] else {
            return
        }
        let response = TvModels.TvItemData.Response(object: request.object,
                                                    indexPath: request.indexPath,
                                                    tvSection: tvSection)
        presenter?.presentTvChannelsHeaderItem(response)
    }

    func fetchTvChannelsItem(_ request: TvModels.TvItemData.Request) {
        guard let tvSection = tvSections[safe: request.indexPath.section] else {
            return
        }
        let response = TvModels.TvItemData.Response(object: request.object,
                                                    indexPath: request.indexPath,
                                                    tvSection: tvSection)
        presenter?.presentTvChannelsItem(response)
    }

    func focusChangedInTvCollection(_ request: TvModels.FocusChangedInTvCollection.Request) {
        guard let tvSection = tvSections[safe: request.nextIndexPath.section] else {
            return
        }
        let response = TvModels.FocusChangedInTvCollection.Response(nextIndexPathItem: request.nextIndexPath.item,
                                                                    tvSection: tvSection)
        presenter?.focusChangedInTvCollection(response)
    }

    func didSelectTvItem(_ request: TvModels.SelectTvItem.Request) {
        guard let selectedSection = tvSections.first(where: { $0.sectionIndex == request.indexPath.section }) else {
            return
        }

        switch selectedSection {
        case .trendingLiveBroadcasts(let liveBroadcasts):
            selectedTvBroadcastItem = liveBroadcasts.items[safe: request.indexPath.item]
        case .trendingChannels(let trendingChannels):
            selectedTvChannelItem = trendingChannels.items[safe: request.indexPath.item]
        }
        
        let response = TvModels.SelectTvItem.Response()
        presenter?.presentSelectedTvItem(response)
    }
}
