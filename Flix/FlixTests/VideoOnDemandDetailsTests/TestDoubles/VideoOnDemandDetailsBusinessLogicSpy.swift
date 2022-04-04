//
//  VideoOnDemandDetailsBusinessLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 17.11.2021.
//

import Foundation
@testable import Flix

final class VideoOnDemandDetailsBusinessLogicSpy {
    // MARK: - Properties
    private (set) var isCalledFetchVideoOnDemandDetails = false
    private (set) var isCalledFetchVideoOnDemandDetailsAction = false
    private (set) var isCalledDidSelectVideoOnDemandDetailsAction = false
}

extension VideoOnDemandDetailsBusinessLogicSpy: VideoOnDemandDetailsBusinessLogic {
    func fetchVideoOnDemandDetails(_ request: VideoOnDemandDetailsModels.InitialData.Request) {
        isCalledFetchVideoOnDemandDetails = true
    }

    func fetchVideoOnDemandDetailsAction(_ request: VideoOnDemandDetailsModels.Action.Request) {
        isCalledFetchVideoOnDemandDetailsAction = true
    }

    func didSelectVideoOnDemandDetailsAction(_ request: VideoOnDemandDetailsModels.SelectVideoOnDemandDetailsAction.Request) {
        isCalledDidSelectVideoOnDemandDetailsAction = true
    }
}
