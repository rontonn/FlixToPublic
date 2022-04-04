//
//  ContentPlayerDisplayLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 19.11.2021.
//

import Foundation
@testable import Flix

final class ContentPlayerDisplayLogicSpy {
    // MARK: - Properties
    private (set) var isCalledDisplayContent = false
    private (set) var isCalledShouldLoadOrRenewRequestedResource = false
    private (set) var isCalledDidHappenAccessLogEvent = false
    private (set) var isCalledDidHappenErrorLogEvent = false
}

extension ContentPlayerDisplayLogicSpy: ContentPlayerDisplayLogic {
    func playContent(_ viewModel: ContentPlayerModels.InitialData.ViewModel) {
        isCalledDisplayContent = true
    }
    
    func shouldLoadOrRenewRequestedResource(_ viewModel: ContentPlayerModels.AssetLoaderData.ViewModel) {
        isCalledShouldLoadOrRenewRequestedResource = true
    }
    
    func didHappenAccessLogEvent(_ viewModel: ContentPlayerModels.LogEvent.ViewModel) {
        isCalledDidHappenAccessLogEvent = true
    }
    
    func didHappenErrorLogEvent(_ viewModel: ContentPlayerModels.LogEvent.ViewModel) {
        isCalledDidHappenErrorLogEvent = true
    }
}
