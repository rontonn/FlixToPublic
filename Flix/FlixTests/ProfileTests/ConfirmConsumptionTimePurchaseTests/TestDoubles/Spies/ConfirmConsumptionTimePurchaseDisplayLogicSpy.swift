//
//  ConfirmConsumptionTimePurchaseDisplayLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 17.11.2021.
//

import Foundation
@testable import Flix

final class ConfirmConsumptionTimePurchaseDisplayLogicSpy {
    // MARK: - Properties
    private (set) var isCalledDisplayPurchaseOption = false
    private (set) var isCalledDidCompletePurchase = false
}

extension ConfirmConsumptionTimePurchaseDisplayLogicSpy: ConfirmConsumptionTimePurchaseDisplayLogic {
    func displayPurchaseOption(_ viewModel: ConfirmConsumptionTimePurchaseModels.InitialData.ViewModel) {
        isCalledDisplayPurchaseOption = true
    }
    
    func didCompletePurchase(_ viewModel: ConfirmConsumptionTimePurchaseModels.MakePurchase.ViewModel) {
        isCalledDidCompletePurchase = true
    }
}
