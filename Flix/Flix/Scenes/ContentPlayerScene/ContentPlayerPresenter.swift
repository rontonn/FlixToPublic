//
//  
//  ContentPlayerPresenter.swift
//  Flix
//
//  Created by Anton Romanov on 12.11.2021.
//
//

protocol ContentPlayerPresentationLogic {
    func presentContent(_ response: ContentPlayerModels.InitialData.Response)
    func shouldLoadOrRenewRequestedResource(_ response: ContentPlayerModels.AssetLoaderData.Response)
    func didHappenAccessLogEvent(_ response: ContentPlayerModels.LogEvent.Response)
    func didHappenErrorLogEvent(_ response: ContentPlayerModels.LogEvent.Response)
}

final class ContentPlayerPresenter {
    // MARK: - Properties
    weak var viewController: ContentPlayerDisplayLogic?
}

extension ContentPlayerPresenter: ContentPlayerPresentationLogic {
    func presentContent(_ response: ContentPlayerModels.InitialData.Response) {
        let viewModel = ContentPlayerModels.InitialData.ViewModel(url: response.url)
        viewController?.playContent(viewModel)
    }

    func shouldLoadOrRenewRequestedResource(_ response: ContentPlayerModels.AssetLoaderData.Response) {
        let viewModel = ContentPlayerModels.AssetLoaderData.ViewModel()
        viewController?.shouldLoadOrRenewRequestedResource(viewModel)
    }

    func didHappenAccessLogEvent(_ response: ContentPlayerModels.LogEvent.Response) {
        let viewModel = ContentPlayerModels.LogEvent.ViewModel()
        viewController?.didHappenAccessLogEvent(viewModel)
    }

    func didHappenErrorLogEvent(_ response: ContentPlayerModels.LogEvent.Response) {
        let viewModel = ContentPlayerModels.LogEvent.ViewModel()
        viewController?.didHappenErrorLogEvent(viewModel)
    }
}
