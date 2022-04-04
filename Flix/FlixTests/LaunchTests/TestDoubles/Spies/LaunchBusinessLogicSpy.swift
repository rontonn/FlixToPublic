//
//  LaunchBusinessLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 15.11.2021.
//

import Foundation
@testable import Flix

final class LaunchBusinessLogicSpy: LaunchBusinessLogic {
    // MARK: - Properties
    private (set) var isCalledRequestPageTitle = false

    // MARK: - Public methods
    func requestPageTitle(_ request: LaunchModels.InitialData.Request) {
        isCalledRequestPageTitle = true
    }
}
