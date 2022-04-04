//
//  AlertBusinessLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 19.11.2021.
//

import Foundation
@testable import Flix

final class AlertBusinessLogicSpy {
    // MARK: - Properties
    private (set) var isCalledFetchAlertData = false
    private (set) var isCalledFetchAlertActionData = false
    private (set) var isCalledDidSelectAlertAction = false
}

extension AlertBusinessLogicSpy: AlertBusinessLogic {
    func fetchAlertData(_ request: AlertModels.InitialData.Request) {
        isCalledFetchAlertData = true
    }

    func fetchAlertActionData(_ request: AlertModels.AlertActionData.Request) {
        isCalledFetchAlertActionData = true
    }

    func didSelectAlertAction(_ request: AlertModels.SelectAlertAction.Request) {
        isCalledDidSelectAlertAction = true
    }
}
