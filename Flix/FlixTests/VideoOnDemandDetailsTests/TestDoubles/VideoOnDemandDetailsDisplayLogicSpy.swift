//
//  VideoOnDemandDetailsDisplayLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 17.11.2021.
//

import Foundation
@testable import Flix

final class VideoOnDemandDetailsDisplayLogicSpy {
    // MARK: - Properties
    private (set) var isCalledDisplayVideoOnDemandDetails = false
    private (set) var isCalledDisplayVideoOnDemandDetailsAction = false
    private (set) var isCalledDisplayContentPlayer = false
    private (set) var isCalledDisplayMoreEpisodes = false
    private (set) var isCalledDisplayRateContent = false
    private (set) var isCalledDisplayWatchLater = false
}

extension VideoOnDemandDetailsDisplayLogicSpy: VideoOnDemandDetailsDisplayLogic {
    func displayVideoOnDemandDetails(_ viewModel: VideoOnDemandDetailsModels.InitialData.ViewModel) {
        isCalledDisplayVideoOnDemandDetails = true
    }

    func displayVideoOnDemandDetailsAction(_ viewModel: VideoOnDemandDetailsModels.Action.ViewModel) {
        isCalledDisplayVideoOnDemandDetailsAction = true
    }

    func displayContentPlayer(_ viewModel: VideoOnDemandDetailsModels.SelectVideoOnDemandDetailsAction.ViewModel) {
        isCalledDisplayContentPlayer = true
    }

    func displayMoreEpisodes(_ viewModel: VideoOnDemandDetailsModels.SelectVideoOnDemandDetailsAction.ViewModel) {
        isCalledDisplayMoreEpisodes = true
    }

    func displayRateContent(_ viewModel: VideoOnDemandDetailsModels.SelectVideoOnDemandDetailsAction.ViewModel) {
        isCalledDisplayRateContent = true
    }
    
    func displayWatchLater(_ viewModel: VideoOnDemandDetailsModels.SelectVideoOnDemandDetailsAction.ViewModel) {
        isCalledDisplayWatchLater = true
    }
}
