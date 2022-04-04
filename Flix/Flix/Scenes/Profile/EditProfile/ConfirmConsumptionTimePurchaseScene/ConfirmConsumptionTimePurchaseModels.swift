//
//  
//  ConfirmConsumptionTimePurchaseModels.swift
//  Flix
//
//  Created by Anton Romanov on 10.11.2021.
//
//

import UIKit

enum ConfirmConsumptionTimePurchaseModels {
    // MARK: - InitialData
    enum InitialData {
        struct Request {}
        struct Response {
            let purchaseOption: PurchaseConsumptionTimeOption
        }
        struct ViewModel {
            let purchaseOption: PurchaseConsumptionTimeOption
        }
    }
    // MARK: - MakePurchase
    enum MakePurchase {
        struct Request {}
        struct Response {}
        struct ViewModel {}
    }
}
