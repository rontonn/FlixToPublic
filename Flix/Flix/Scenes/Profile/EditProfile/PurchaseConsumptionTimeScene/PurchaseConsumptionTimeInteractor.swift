//
//  
//  PurchaseConsumptionTimeInteractor.swift
//  Flix
//
//  Created by Anton Romanov on 09.11.2021.
//
//

import UIKit

protocol PurchaseConsumptionTimeBusinessLogic {
    func fetchPurchaseOptions(_ request: PurchaseConsumptionTimeModels.InitialData.Request)
    func fetchPurchaseOption(_ request: PurchaseConsumptionTimeModels.PurchaseConsumptionTimeOptionData.Request)
    func fetchSupplementaryView(_ request: PurchaseConsumptionTimeModels.PurchaseConsumptionTimeSupplementaryViewData.Request)
    func didSelectPurchaseOption(_ request: PurchaseConsumptionTimeModels.SelectedPurchaseOption.Request)
}

protocol PurchaseConsumptionTimeDataStore {
    var availableConsumptionTime: String? { get set }
    var selectedPurchaseOption: PurchaseConsumptionTimeOption? { get }
    var purchaseOptions: [PurchaseConsumptionTimeOption] { get }
}

final class PurchaseConsumptionTimeInteractor: PurchaseConsumptionTimeDataStore {
    // MARK: - Properties
    var presenter: PurchaseConsumptionTimePresentationLogic?
    var availableConsumptionTime: String?
    var selectedPurchaseOption: PurchaseConsumptionTimeOption?
    var purchaseOptions: [PurchaseConsumptionTimeOption] = []
}

extension PurchaseConsumptionTimeInteractor: PurchaseConsumptionTimeBusinessLogic {
    func fetchPurchaseOptions(_ request: PurchaseConsumptionTimeModels.InitialData.Request) {
        purchaseOptions = [PurchaseConsumptionTimeOption(hours: 20, price: 240, reward: 10),
                           PurchaseConsumptionTimeOption(hours: 30, price: 260, reward: 20),
                           PurchaseConsumptionTimeOption(hours: 40, price: 280, reward: 30),
                           PurchaseConsumptionTimeOption(hours: 50, price: 300, reward: 40),
                           PurchaseConsumptionTimeOption(hours: 60, price: 320, reward: 50),
                           PurchaseConsumptionTimeOption(hours: 70, price: 340, reward: 60),
                           PurchaseConsumptionTimeOption(hours: 80, price: 360, reward: 70),
                           PurchaseConsumptionTimeOption(hours: 90, price: 380, reward: 80),
                           PurchaseConsumptionTimeOption(hours: 100, price: 400, reward: 90),
                           PurchaseConsumptionTimeOption(hours: 200, price: 700, reward: 200)]
        let response = PurchaseConsumptionTimeModels.InitialData.Response(purchaseOptions: purchaseOptions,
                                                                          availableConsumptionTime: availableConsumptionTime)
        presenter?.presentPurchaseOptions(response)
    }

    func fetchPurchaseOption(_ request: PurchaseConsumptionTimeModels.PurchaseConsumptionTimeOptionData.Request) {
        guard let option = purchaseOptions[safe: request.indexPath.item] else {
            return
        }
        let response = PurchaseConsumptionTimeModels.PurchaseConsumptionTimeOptionData.Response(object: request.object, option: option)
        presenter?.presentPurchaseOption(response)
    }

    func fetchSupplementaryView(_ request: PurchaseConsumptionTimeModels.PurchaseConsumptionTimeSupplementaryViewData.Request) {
        let subtitle = "available_balance_title".localized + " 100 000 USDT"
        let header = PurchaseConsumptionTimeSupplementaryView.Header(title: "pick_additional_item_title".localized,
                                                                     subtitle: subtitle,
                                                                     accessoryImage: UIImage(named: "coloredMovieIcon"))
        let response = PurchaseConsumptionTimeModels.PurchaseConsumptionTimeSupplementaryViewData.Response(object: request.object, header: header)
        presenter?.presentSupplementaryView(response)
    }

    func didSelectPurchaseOption(_ request: PurchaseConsumptionTimeModels.SelectedPurchaseOption.Request) {
        guard let purchaseOption = purchaseOptions[safe: request.indexPath.item] else {
            return
        }
        selectedPurchaseOption = purchaseOption
        let response = PurchaseConsumptionTimeModels.SelectedPurchaseOption.Response()
        presenter?.presentSelectedPurchaseOption(response)
    }
}
