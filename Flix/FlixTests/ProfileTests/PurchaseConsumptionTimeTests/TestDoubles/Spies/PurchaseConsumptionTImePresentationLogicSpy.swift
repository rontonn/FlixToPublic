//
//  PurchaseConsumptionTImePresentationLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 17.11.2021.
//

import Foundation
@testable import Flix

final class PurchaseConsumptionTImePresentationLogicSpy {
    // MARK: - Properties
    private (set) var isCalledPresentPurchaseOptions = false
    private (set) var isCalledPresentPurchaseOption = false
    private (set) var isCalledPresentSupplementaryView = false
    private (set) var isCalledPresentSelectedPurchaseOption = false
}

extension PurchaseConsumptionTImePresentationLogicSpy: PurchaseConsumptionTimePresentationLogic {
    func presentPurchaseOptions(_ response: PurchaseConsumptionTimeModels.InitialData.Response) {
        isCalledPresentPurchaseOptions = true
    }
    
    func presentPurchaseOption(_ response: PurchaseConsumptionTimeModels.PurchaseConsumptionTimeOptionData.Response) {
        isCalledPresentPurchaseOption = true
    }
    
    func presentSupplementaryView(_ response: PurchaseConsumptionTimeModels.PurchaseConsumptionTimeSupplementaryViewData.Response) {
        isCalledPresentSupplementaryView = true
    }
    
    func presentSelectedPurchaseOption(_ response: PurchaseConsumptionTimeModels.SelectedPurchaseOption.Response) {
        isCalledPresentSelectedPurchaseOption = true
    }
}
