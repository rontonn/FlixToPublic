//
//  ContentPlayerPresentationLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 19.11.2021.
//

import Foundation
@testable import Flix

final class ContentPlayerPresentationLogicSpy {
    // MARK: - Properties
    private (set) var isCalledPresentContent = false
    private (set) var isCalledShouldLoadOrRenewRequestedResource = false
    private (set) var isCalledDidHappenAccessLogEvent = false
    private (set) var isCalledDidHappenErrorLogEvent = false
}

extension ContentPlayerPresentationLogicSpy: ContentPlayerPresentationLogic {
    func presentContent(_ response: ContentPlayerModels.InitialData.Response) {
        isCalledPresentContent = true
    }
    
    func shouldLoadOrRenewRequestedResource(_ response: ContentPlayerModels.AssetLoaderData.Response) {
        isCalledShouldLoadOrRenewRequestedResource = true
    }
    
    func didHappenAccessLogEvent(_ response: ContentPlayerModels.LogEvent.Response) {
        isCalledDidHappenAccessLogEvent = true
    }
    
    func didHappenErrorLogEvent(_ response: ContentPlayerModels.LogEvent.Response) {
        isCalledDidHappenErrorLogEvent = true
    }
}
