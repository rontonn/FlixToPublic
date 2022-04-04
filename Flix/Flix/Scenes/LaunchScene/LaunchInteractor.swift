//
//  
//  LaunchInteractor.swift
//  FlixAR
//
//  Created by Anton Romanov on 12.10.2021.
//
//

protocol LaunchBusinessLogic {
    func requestPageTitle(_ request: LaunchModels.InitialData.Request)
}

protocol LaunchDataStore {
}

final class LaunchInteractor: LaunchDataStore {
    // MARK: - Properties
    var presenter: LaunchPresentationLogic?
}

extension LaunchInteractor: LaunchBusinessLogic {
    func requestPageTitle(_ request: LaunchModels.InitialData.Request) {
        let response = LaunchModels.InitialData.Response()
        presenter?.presentPageTitle(response)
    }
}
