//
//  PurchaseConsumptionTImeDisplayLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 17.11.2021.
//

import Foundation
@testable import Flix

final class PurchaseConsumptionTImeDisplayLogicSpy {
    // MARK: - Properties
    private (set) var isCalledDisplayPurchaseOptions = false
    private (set) var isCalledDisplayPurchaseOption = false
    private (set) var isCalledDisplaySupplementaryView = false
    private (set) var isCalledDisplaySelectedPurchaseOption = false
}

extension PurchaseConsumptionTImeDisplayLogicSpy: PurchaseConsumptionTimeDisplayLogic {
    func displayPurchaseOptions(_ viewModel: PurchaseConsumptionTimeModels.InitialData.ViewModel) {
        isCalledDisplayPurchaseOptions = true
    }
    
    func displayPurchaseOption(_ viewModel: PurchaseConsumptionTimeModels.PurchaseConsumptionTimeOptionData.ViewModel) {
        isCalledDisplayPurchaseOption = true
    }
    
    func displaySupplementaryView(_ viewModel: PurchaseConsumptionTimeModels.PurchaseConsumptionTimeSupplementaryViewData.ViewModel) {
        isCalledDisplaySupplementaryView = true
    }
    
    func displaySelectedPurchaseOption(_ viewModel: PurchaseConsumptionTimeModels.SelectedPurchaseOption.ViewModel) {
        isCalledDisplaySelectedPurchaseOption = true
    }
}
