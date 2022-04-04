//
//  AlertPresentationLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 19.11.2021.
//

import Foundation
@testable import Flix

final class AlertPresentationLogicSpy {
    // MARK: - Properties
    private (set) var isCalledPresentAlert = false
    private (set) var isCalledPresentAlertActionData = false
    private (set) var isCalledPresentSelectedAlertAction = false
}

extension AlertPresentationLogicSpy: AlertPresentationLogic {
    func presentAlert(_ response: AlertModels.InitialData.Response) {
        isCalledPresentAlert = true
    }
    
    func presentAlertActionData(_ response: AlertModels.AlertActionData.Response) {
        isCalledPresentAlertActionData = true
    }
    
    func presentSelectedAlertAction(_ response: AlertModels.SelectAlertAction.Response) {
        isCalledPresentSelectedAlertAction = true
    }
}
