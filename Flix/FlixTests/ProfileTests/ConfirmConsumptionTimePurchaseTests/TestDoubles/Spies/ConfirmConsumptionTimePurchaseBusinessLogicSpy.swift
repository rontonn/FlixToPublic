//
//  ConfirmConsumptionTimePurchaseBusinessLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 17.11.2021.
//

import Foundation
@testable import Flix

final class ConfirmConsumptionTimePurchaseBusinessLogicSpy {
    // MARK: - Properties
    private (set) var isCalledFetchPurchaseOption = false
    private (set) var isCalledDidPressApproveConsumptionTimePurchase = false
}

extension ConfirmConsumptionTimePurchaseBusinessLogicSpy: ConfirmConsumptionTimePurchaseBusinessLogic {
    func fetchPurchaseOption(_ request: ConfirmConsumptionTimePurchaseModels.InitialData.Request) {
        isCalledFetchPurchaseOption = true
    }
    
    func didPressApproveConsumptionTimePurchase(_ request: ConfirmConsumptionTimePurchaseModels.MakePurchase.Request) {
        isCalledDidPressApproveConsumptionTimePurchase = true
    }
}
