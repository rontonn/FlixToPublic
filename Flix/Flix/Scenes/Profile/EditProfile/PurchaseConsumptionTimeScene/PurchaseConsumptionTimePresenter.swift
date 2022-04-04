//
//  
//  PurchaseConsumptionTimePresenter.swift
//  Flix
//
//  Created by Anton Romanov on 09.11.2021.
//
//

import UIKit

protocol PurchaseConsumptionTimePresentationLogic {
    func presentPurchaseOptions(_ response: PurchaseConsumptionTimeModels.InitialData.Response)
    func presentPurchaseOption(_ response: PurchaseConsumptionTimeModels.PurchaseConsumptionTimeOptionData.Response)
    func presentSupplementaryView(_ response: PurchaseConsumptionTimeModels.PurchaseConsumptionTimeSupplementaryViewData.Response)
    func presentSelectedPurchaseOption(_ response: PurchaseConsumptionTimeModels.SelectedPurchaseOption.Response)
}

final class PurchaseConsumptionTimePresenter {
    // MARK: - Properties
    weak var viewController: PurchaseConsumptionTimeDisplayLogic?

    private let purchaseConsumptionOptionsSectionUUID = UUID()
}

extension PurchaseConsumptionTimePresenter: PurchaseConsumptionTimePresentationLogic {
    func presentPurchaseOptions(_ response: PurchaseConsumptionTimeModels.InitialData.Response) {
        let purchaseConsumptionTimeCollectionLayoutSource = PurchaseConsumptionTimeCollectionLayoutSource()
        let layout = purchaseConsumptionTimeCollectionLayoutSource.createLayout()

        let snapshot = dataSourceSnapshotFor(response.purchaseOptions)
        let viewModel = PurchaseConsumptionTimeModels.InitialData.ViewModel(dataSourceSnapshot: snapshot,
                                                                            layout: layout,
                                                                            availableConsumptionTime: response.availableConsumptionTime)
        viewController?.displayPurchaseOptions(viewModel)
    }

    func presentPurchaseOption(_ response: PurchaseConsumptionTimeModels.PurchaseConsumptionTimeOptionData.Response) {
        let viewModel = PurchaseConsumptionTimeModels.PurchaseConsumptionTimeOptionData.ViewModel(object: response.object, option: response.option)
        viewController?.displayPurchaseOption(viewModel)
    }

    func presentSupplementaryView(_ response: PurchaseConsumptionTimeModels.PurchaseConsumptionTimeSupplementaryViewData.Response) {
        let viewModel = PurchaseConsumptionTimeModels.PurchaseConsumptionTimeSupplementaryViewData.ViewModel(object: response.object, header: response.header)
        viewController?.displaySupplementaryView(viewModel)
    }

    func presentSelectedPurchaseOption(_ response: PurchaseConsumptionTimeModels.SelectedPurchaseOption.Response) {
        let viewModel = PurchaseConsumptionTimeModels.SelectedPurchaseOption.ViewModel()
        viewController?.displaySelectedPurchaseOption(viewModel)
    }
}

// MARK: - Private methods
private extension PurchaseConsumptionTimePresenter {
    func dataSourceSnapshotFor(_ options: [PurchaseConsumptionTimeOption]) -> NSDiffableDataSourceSnapshot<UUID, UUID> {
        
        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        snapshot.appendSections([purchaseConsumptionOptionsSectionUUID])
        let uuids = options.map{ $0.id }
        snapshot.appendItems(uuids)
        return snapshot
    }
}
