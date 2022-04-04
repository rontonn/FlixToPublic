//
//  
//  EditNamePresenter.swift
//  Flix
//
//  Created by Anton Romanov on 05.11.2021.
//
//

protocol EditNamePresentationLogic {
    func presentCurrentName(_ response: EditNameModels.InitialData.Response)
    func presentEditNameSuccess(_ response: EditNameModels.Result.Response)
    func presentEditNameError(_ response: EditNameModels.Result.Response)
}

final class EditNamePresenter {
    // MARK: - Properties
    weak var viewController: EditNameDisplayLogic?
}

extension EditNamePresenter: EditNamePresentationLogic {
    func presentCurrentName(_ response: EditNameModels.InitialData.Response) {
        let viewModel = EditNameModels.InitialData.ViewModel(name: response.name)
        viewController?.displayCurrentName(viewModel)
    }

    func presentEditNameSuccess(_ response: EditNameModels.Result.Response) {
        let viewModel = EditNameModels.Result.ViewModel()
        viewController?.displayEditNameSuccess(viewModel)
    }

    func presentEditNameError(_ response: EditNameModels.Result.Response) {
        let viewModel = EditNameModels.Result.ViewModel()
        viewController?.displayEditNameError(viewModel)
    }
}
