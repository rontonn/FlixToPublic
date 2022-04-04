//
//  LaunchPresentationLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 15.11.2021.
//

import Foundation
@testable import Flix

final class LaunchPresentationLogicSpy: LaunchPresentationLogic {
    // MARK: - Properties
    private (set) var isCalledPresentPageTitle = false

    // MARK: - Public methods
    func presentPageTitle(_ response: LaunchModels.InitialData.Response) {
        isCalledPresentPageTitle = true
    }
}
