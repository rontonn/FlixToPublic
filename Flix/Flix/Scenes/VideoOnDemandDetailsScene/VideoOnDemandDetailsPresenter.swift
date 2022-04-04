//
//  
//  VideoOnDemandDetailsPresenter.swift
//  Flix
//
//  Created by Anton Romanov on 21.10.2021.
//
//

import UIKit

protocol VideoOnDemandDetailsPresentationLogic {
    func presentVideoOnDemandDetails(_ response: VideoOnDemandDetailsModels.InitialData.Response)
    func presentVideoOnDemandDetailsAction(_ response: VideoOnDemandDetailsModels.Action.Response)
    func presentSelectedVideoOnDemandDetailsAction(_ response: VideoOnDemandDetailsModels.SelectVideoOnDemandDetailsAction.Response)
}

final class VideoOnDemandDetailsPresenter {
    // MARK: - Properties
    weak var viewController: VideoOnDemandDetailsDisplayLogic?

    private let actionsSectionUUID = UUID()
}

extension VideoOnDemandDetailsPresenter: VideoOnDemandDetailsPresentationLogic {
    func presentVideoOnDemandDetails(_ response: VideoOnDemandDetailsModels.InitialData.Response) {
        let videoOnDemandDetailsCollectionLayoutSource = VideoOnDemandDetailsCollectionLayoutSource()
        let layout = videoOnDemandDetailsCollectionLayoutSource.createLayout()

        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        snapshot.appendSections([actionsSectionUUID])
        let uuids = response.actions.map{ $0.id }
        snapshot.appendItems(uuids)

        let viewModel = VideoOnDemandDetailsModels.InitialData.ViewModel(dataSourceSnapshot: snapshot,
                                                                         layout: layout,
                                                                         videoOnDemandItem: response.videoOnDemandItem)
        viewController?.displayVideoOnDemandDetails(viewModel)
    }

    func presentVideoOnDemandDetailsAction(_ response: VideoOnDemandDetailsModels.Action.Response) {
        let viewModel = VideoOnDemandDetailsModels.Action.ViewModel(object: response.object, action: response.action)
        viewController?.displayVideoOnDemandDetailsAction(viewModel)
    }

    func presentSelectedVideoOnDemandDetailsAction(_ response: VideoOnDemandDetailsModels.SelectVideoOnDemandDetailsAction.Response) {
        let viewModel = VideoOnDemandDetailsModels.SelectVideoOnDemandDetailsAction.ViewModel()
        switch response.option {
        case .play:
            viewController?.displayContentPlayer(viewModel)
        case .rate:
            viewController?.displayRateContent(viewModel)
        case .watchLater:
            viewController?.displayWatchLater(viewModel)
        case .moreEpisodes:
            viewController?.displayMoreEpisodes(viewModel)
        }
    }
}
