//
//  
//  LaunchPresenter.swift
//  FlixAR
//
//  Created by Anton Romanov on 12.10.2021.
//
//

protocol LaunchPresentationLogic {
    func presentPageTitle(_ response: LaunchModels.InitialData.Response)
}

final class LaunchPresenter {
    // MARK: - Properties
    weak var viewController: LaunchDisplayLogic?
}

extension LaunchPresenter: LaunchPresentationLogic {
    func presentPageTitle(_ response: LaunchModels.InitialData.Response) {
        let viewModel = LaunchModels.InitialData.ViewModel(pageTitle: "flix_slogan_title".localized)
        viewController?.displayTitle(viewModel)
    }
}
