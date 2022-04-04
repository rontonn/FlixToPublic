//
//  
//  VideoOnDemandDetailsInteractor.swift
//  Flix
//
//  Created by Anton Romanov on 21.10.2021.
//
//

protocol VideoOnDemandDetailsBusinessLogic {
    func fetchVideoOnDemandDetails(_ request: VideoOnDemandDetailsModels.InitialData.Request)
    func fetchVideoOnDemandDetailsAction(_ request: VideoOnDemandDetailsModels.Action.Request)
    func didSelectVideoOnDemandDetailsAction(_ request: VideoOnDemandDetailsModels.SelectVideoOnDemandDetailsAction.Request)
}

protocol VideoOnDemandDetailsDataStore {
    var videoOnDemandItem: VideoOnDemandItemDetails? { get }
    var actions: [VideoOnDemandDetailsAction] { get }
}

final class VideoOnDemandDetailsInteractor: VideoOnDemandDetailsDataStore {
    // MARK: - Properties
    var presenter: VideoOnDemandDetailsPresentationLogic?
    var videoOnDemandItem: VideoOnDemandItemDetails?
    var actions: [VideoOnDemandDetailsAction] = []
}

extension VideoOnDemandDetailsInteractor: VideoOnDemandDetailsBusinessLogic {
    func fetchVideoOnDemandDetails(_ request: VideoOnDemandDetailsModels.InitialData.Request) {
        actions = [VideoOnDemandDetailsAction(option: .play),
                   VideoOnDemandDetailsAction(option: .moreEpisodes),
                   VideoOnDemandDetailsAction(option: .watchLater),
                   VideoOnDemandDetailsAction(option: .rate)]

        let videoOnDemandItem = VideoOnDemandItemDetails(title: "Free Guy", poster: "freeGuyPoster", consumptionTime: "Available consumption time 35h 20min", country: "USA", year: "2021", genres: [.action, .crime, .comedy], rating: .imbd(ratingValue: "8,7"), description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum commodo pellentesque porta. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. ")

        self.videoOnDemandItem = videoOnDemandItem
        let response = VideoOnDemandDetailsModels.InitialData.Response(videoOnDemandItem: videoOnDemandItem,
                                                                       actions: actions)
        presenter?.presentVideoOnDemandDetails(response)
    }

    func fetchVideoOnDemandDetailsAction(_ request: VideoOnDemandDetailsModels.Action.Request) {
        guard let action = actions[safe: request.indexPath.item] else {
            return
        }
        let response = VideoOnDemandDetailsModels.Action.Response(object: request.object, action: action)
        presenter?.presentVideoOnDemandDetailsAction(response)
    }

    func didSelectVideoOnDemandDetailsAction(_ request: VideoOnDemandDetailsModels.SelectVideoOnDemandDetailsAction.Request) {
        guard let action = actions[safe: request.indexPath.item] else {
            return
        }
        let response = VideoOnDemandDetailsModels.SelectVideoOnDemandDetailsAction.Response(option: action.option)
        presenter?.presentSelectedVideoOnDemandDetailsAction(response)
    }
}
