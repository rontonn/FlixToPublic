//
//  
//  ErrorInteractor.swift
//  Flix
//
//  Created by Anton Romanov on 29.10.2021.
//
//

protocol ErrorBusinessLogic {
    func fetchErrorInfo(_ request: ErrorModels.InitialData.Request)
    func fetchErrorActionData(_ request: ErrorModels.ErrorActionData.Request)
    func didSelectErrorAction(_ request: ErrorModels.SelectErrorAction.Request)
}

protocol ErrorDataStore {
    var error: PriviError? { get set }
}

final class ErrorInteractor: ErrorDataStore {
    // MARK: - Properties
    var presenter: ErrorPresentationLogic?
    var error: PriviError?
}

extension ErrorInteractor: ErrorBusinessLogic {
    func fetchErrorInfo(_ request: ErrorModels.InitialData.Request) {
        guard let error = error else {
            return
        }
        let response = ErrorModels.InitialData.Response(error: error)
        presenter?.presentError(response)
    }

    func fetchErrorActionData(_ request: ErrorModels.ErrorActionData.Request) {
        guard let action = error?.actions[safe: request.indexPath.item] else {
            return
        }
        let response = ErrorModels.ErrorActionData.Response(object: request.object, action: action)
        presenter?.presentErrorActionData(response)
    }

    func didSelectErrorAction(_ request: ErrorModels.SelectErrorAction.Request) {
        guard let action = error?.actions[safe: request.indexPath.item] else {
            return
        }
        let response = ErrorModels.SelectErrorAction.Response(action: action)
        presenter?.presentSelectedErrorAction(response)
    }
}
