//
//  LaunchDisplayLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 15.11.2021.
//

import Foundation
@testable import Flix

final class LaunchDisplayLogicSpy: LaunchDisplayLogic {
    // MARK: - Properties
    private (set) var isCalledDisplayTitle = false

    // MARK: - Public methods
    func displayTitle(_ viewModel: LaunchModels.InitialData.ViewModel) {
        isCalledDisplayTitle = true
    }
}
