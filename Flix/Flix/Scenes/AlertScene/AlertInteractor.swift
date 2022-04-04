//
//  
//  AlertInteractor.swift
//  Flix
//
//  Created by Anton Romanov on 11.11.2021.
//
//

protocol AlertBusinessLogic {
    func fetchAlertData(_ request: AlertModels.InitialData.Request)
    func fetchAlertActionData(_ request: AlertModels.AlertActionData.Request)
    func didSelectAlertAction(_ request: AlertModels.SelectAlertAction.Request)
}

protocol AlertDataStore {
    var info: AlertModels.Info? { get set }
    var actions: [AlertAction] { get }
}

final class AlertInteractor: AlertDataStore {
    // MARK: - Properties
    var presenter: AlertPresentationLogic?
    var info: AlertModels.Info?
    var actions: [AlertAction] = []
}

extension AlertInteractor: AlertBusinessLogic {
    func fetchAlertData(_ request: AlertModels.InitialData.Request) {
        guard let info = info else {
            return
        }
        actions = [AlertAction(option: .close)]
        let response = AlertModels.InitialData.Response(info: info, actions: actions)
        presenter?.presentAlert(response)
    }

    func fetchAlertActionData(_ request: AlertModels.AlertActionData.Request) {
        guard let action = actions[safe: request.indexPath.item] else {
            return
        }
        let response = AlertModels.AlertActionData.Response(object: request.object, action: action)
        presenter?.presentAlertActionData(response)
    }

    func didSelectAlertAction(_ request: AlertModels.SelectAlertAction.Request) {
        guard let action = actions[safe: request.indexPath.item] else {
            return
        }
        let response = AlertModels.SelectAlertAction.Response(action: action)
        presenter?.presentSelectedAlertAction(response)
    }
}
