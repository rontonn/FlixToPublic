//
//  ContentPlayerBusinessLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 19.11.2021.
//

import Foundation
@testable import Flix

final class ContentPlayerBusinessLogicSpy {
    // MARK: - Properties
    private (set) var isCalledFetchURLToPlay = false
    private (set) var isCalledShouldLoadOrRenewRequestedResource = false
    private (set) var isCalledDidHappenAccessLogEvent = false
    private (set) var isCalledDidHappenErrorLogEvent = false
}

extension ContentPlayerBusinessLogicSpy: ContentPlayerBusinessLogic {
    func fetchURLToPlay(_ request: ContentPlayerModels.InitialData.Request) async {
        isCalledFetchURLToPlay = true
    }
    
    func shouldLoadOrRenewRequestedResource(_ request: ContentPlayerModels.AssetLoaderData.Request) {
        isCalledShouldLoadOrRenewRequestedResource = true
    }
    
    func didHappenAccessLogEvent(_ request: ContentPlayerModels.LogEvent.Request) {
        isCalledDidHappenAccessLogEvent = true
    }
    
    func didHappenErrorLogEvent(_ request: ContentPlayerModels.LogEvent.Request) {
        isCalledDidHappenErrorLogEvent = true
    }
}
