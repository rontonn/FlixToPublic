//
//  
//  PurchaseConsumptionTimeModels.swift
//  Flix
//
//  Created by Anton Romanov on 09.11.2021.
//
//

import UIKit

enum PurchaseConsumptionTimeModels {
    // MARK: - InitialData
    enum InitialData {
        struct Request {}
        struct Response {
            let purchaseOptions: [PurchaseConsumptionTimeOption]
            let availableConsumptionTime: String?
        }
        struct ViewModel {
            let dataSourceSnapshot: NSDiffableDataSourceSnapshot<UUID, UUID>
            let layout: UICollectionViewLayout
            let availableConsumptionTime: String?
        }
    }
    // MARK: - PurchaseConsumptionTimeOption
    enum PurchaseConsumptionTimeOptionData {
        struct Request {
            let object: AnyObject?
            let indexPath: IndexPath
        }
        struct Response {
            let object: AnyObject?
            let option: PurchaseConsumptionTimeOption
        }
        struct ViewModel {
            let object: AnyObject?
            let option: PurchaseConsumptionTimeOption
        }
    }
    // MARK: - PurchaseConsumptionTimeSupplementaryViewData
    enum PurchaseConsumptionTimeSupplementaryViewData {
        struct Request {
            let object: AnyObject?
            let indexPath: IndexPath
        }
        struct Response {
            let object: AnyObject?
            let header: PurchaseConsumptionTimeSupplementaryView.Header
        }
        struct ViewModel {
            let object: AnyObject?
            let header: PurchaseConsumptionTimeSupplementaryView.Header
        }
    }

    // MARK: - SelectedPurchaseOption
    enum SelectedPurchaseOption {
        struct Request {
            let indexPath: IndexPath
        }
        struct Response {}
        struct ViewModel {}
    }
}
