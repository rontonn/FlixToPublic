//
//  
//  AlertPresenter.swift
//  Flix
//
//  Created by Anton Romanov on 11.11.2021.
//
//
import UIKit

protocol AlertPresentationLogic {
    func presentAlert(_ response: AlertModels.InitialData.Response)
    func presentAlertActionData(_ response: AlertModels.AlertActionData.Response)
    func presentSelectedAlertAction(_ response: AlertModels.SelectAlertAction.Response)
}

final class AlertPresenter {
    // MARK: - Properties
    weak var viewController: AlertDisplayLogic?

    private let alertOptionsSectionUUID = UUID()
}

extension AlertPresenter: AlertPresentationLogic {
    func presentAlert(_ response: AlertModels.InitialData.Response) {
        let alertCollectionLayoutSource = AlertCollectionLayoutSource()
        let layout = alertCollectionLayoutSource.createLayout()

        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        snapshot.appendSections([alertOptionsSectionUUID])

        let uuids = response.actions.map{ $0.id }
        snapshot.appendItems(uuids)

        let viewModel = AlertModels.InitialData.ViewModel(info: response.info,
                                                          dataSourceSnapshot: snapshot,
                                                          layout: layout)
        viewController?.displayAlert(viewModel)
    }

    func presentAlertActionData(_ response: AlertModels.AlertActionData.Response) {
        let viewModel = AlertModels.AlertActionData.ViewModel(object: response.object, title: response.action.title)
        viewController?.displayAlertActionData(viewModel)
    }

    func presentSelectedAlertAction(_ response: AlertModels.SelectAlertAction.Response) {
        let viewModel = AlertModels.SelectAlertAction.ViewModel()
        switch response.action.option {
        case .close:
            viewController?.closeAlert(viewModel)
        }
    }
}
