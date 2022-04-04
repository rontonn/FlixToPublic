//
//  PurchaseConsumptionTImeBusinessLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 17.11.2021.
//

import Foundation
@testable import Flix

final class PurchaseConsumptionTImeBusinessLogicSpy {
    // MARK: - Properties
    private (set) var isCalledFetchPurchaseOptions = false
    private (set) var isCalledFetchPurchaseOption = false
    private (set) var isCalledFetchSupplementaryView = false
    private (set) var isCalledDidSelectPurchaseOption = false
}

extension PurchaseConsumptionTImeBusinessLogicSpy: PurchaseConsumptionTimeBusinessLogic {
    func fetchPurchaseOptions(_ request: PurchaseConsumptionTimeModels.InitialData.Request) {
        isCalledFetchPurchaseOptions = true
    }
    
    func fetchPurchaseOption(_ request: PurchaseConsumptionTimeModels.PurchaseConsumptionTimeOptionData.Request) {
        isCalledFetchPurchaseOption = true
    }
    
    func fetchSupplementaryView(_ request: PurchaseConsumptionTimeModels.PurchaseConsumptionTimeSupplementaryViewData.Request) {
        isCalledFetchSupplementaryView = true
    }
    
    func didSelectPurchaseOption(_ request: PurchaseConsumptionTimeModels.SelectedPurchaseOption.Request) {
        isCalledDidSelectPurchaseOption = true
    }
}
