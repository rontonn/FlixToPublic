//
//  
//  EditNameInteractor.swift
//  Flix
//
//  Created by Anton Romanov on 05.11.2021.
//
//

protocol EditNameBusinessLogic {
    func fetchCurrentName(_ request: EditNameModels.InitialData.Request)
    func didPressSaveNameButton(_ request: EditNameModels.Result.Request)
}

protocol EditNameDataStore {
    var currentName: String? { get set }
    var editNameResultableDelegate: EditNameResultable? { get set }
    var error: PriviError? { get }
}

final class EditNameInteractor: EditNameDataStore {
    // MARK: - Properties
    var presenter: EditNamePresentationLogic?
    var currentName: String?
    var error: PriviError?
    weak var editNameResultableDelegate: EditNameResultable?
}

extension EditNameInteractor: EditNameBusinessLogic {
    func fetchCurrentName(_ request: EditNameModels.InitialData.Request) {
        let response = EditNameModels.InitialData.Response(name: currentName)
        presenter?.presentCurrentName(response)
    }

    func didPressSaveNameButton(_ request: EditNameModels.Result.Request) {
        if let newName = request.newName, isNewNameValid(newName) {
            editNameSuccessed(newName)
            editNameResultableDelegate?.didEditName(request)
        } else {
            editNameFailed()
        }
    }
}

// Mark: - Private methods
private extension EditNameInteractor {
    func isNewNameValid(_ name: String) -> Bool {
        if let currentName = currentName,
           currentName == name {
            return false
        }
        return !name.isEmpty
    }

    func editNameSuccessed(_ newName: String) {
        error = nil
        currentName = newName

        let response = EditNameModels.Result.Response()
        presenter?.presentEditNameSuccess(response)
    }

    func editNameFailed() {
        error = PriviError(title: "Edit name has failed!",
                           msg: "Name must not be empty or equal to the previous name.",
                           actions: [PriviErrorAction(option: .close)])

        let response = EditNameModels.Result.Response()
        presenter?.presentEditNameError(response)
    }
}
