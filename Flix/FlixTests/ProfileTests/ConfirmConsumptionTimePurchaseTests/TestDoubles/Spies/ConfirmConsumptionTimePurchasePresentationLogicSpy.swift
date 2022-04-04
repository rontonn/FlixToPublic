//
//  ConfirmConsumptionTimePurchasePresentationLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 17.11.2021.
//

import Foundation
@testable import Flix

final class ConfirmConsumptionTimePurchasePresentationLogicSpy {
    // MARK: - Properties
    private (set) var isCalledPresentPurchaseOption = false
    private (set) var isCalledDidCompletePurchase = false
}

extension ConfirmConsumptionTimePurchasePresentationLogicSpy: ConfirmConsumptionTimePurchasePresentationLogic {
    func presentPurchaseOption(_ response: ConfirmConsumptionTimePurchaseModels.InitialData.Response) {
        isCalledPresentPurchaseOption = true
    }
    
    func didCompletePurchase(_ response: ConfirmConsumptionTimePurchaseModels.MakePurchase.Response) {
        isCalledDidCompletePurchase = true
    }
}
