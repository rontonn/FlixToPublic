//
//  VideoOnDemandDetailsPresentationLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 17.11.2021.
//

import Foundation
@testable import Flix

final class VideoOnDemandDetailsPresentationLogicSpy {
    // MARK: - Properties
    private (set) var isCalledPresentVideoOnDemandDetails = false
    private (set) var isCalledPresentVideoOnDemandDetailsAction = false
    private (set) var isCalledPresentSelectedVideoOnDemandDetailsAction = false
}

extension VideoOnDemandDetailsPresentationLogicSpy: VideoOnDemandDetailsPresentationLogic {
    func presentVideoOnDemandDetails(_ response: VideoOnDemandDetailsModels.InitialData.Response) {
        isCalledPresentVideoOnDemandDetails = true
    }

    func presentVideoOnDemandDetailsAction(_ response: VideoOnDemandDetailsModels.Action.Response) {
        isCalledPresentVideoOnDemandDetailsAction = true
    }

    func presentSelectedVideoOnDemandDetailsAction(_ response: VideoOnDemandDetailsModels.SelectVideoOnDemandDetailsAction.Response) {
        isCalledPresentSelectedVideoOnDemandDetailsAction = true
    }
}
