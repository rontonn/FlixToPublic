//
//  
//  ErrorPresenter.swift
//  Flix
//
//  Created by Anton Romanov on 29.10.2021.
//
//
import UIKit

protocol ErrorPresentationLogic {
    func presentError(_ reponse: ErrorModels.InitialData.Response)
    func presentErrorActionData(_ reponse: ErrorModels.ErrorActionData.Response)
    func presentSelectedErrorAction(_ response: ErrorModels.SelectErrorAction.Response)
}

final class ErrorPresenter {
    // MARK: - Properties
    weak var viewController: ErrorDisplayLogic?

    private let errorActonsSectionUUID = UUID()
}

extension ErrorPresenter: ErrorPresentationLogic {
    func presentError(_ reponse: ErrorModels.InitialData.Response) {
        let errorCollectionLayoutSource = ErrorCollectionLayoutSource()
        let layout = errorCollectionLayoutSource.createLayout()

        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        snapshot.appendSections([errorActonsSectionUUID])

        let uuids = reponse.error.actions.map{ $0.id }
        snapshot.appendItems(uuids)

        let viewModel = ErrorModels.InitialData.ViewModel(description: reponse.error.errorDescription,
                                                          image: reponse.error.image,
                                                          dataSourceSnapshot: snapshot,
                                                          layout: layout)
        viewController?.displayError(viewModel)
    }

    func presentErrorActionData(_ reponse: ErrorModels.ErrorActionData.Response) {
        let viewModel = ErrorModels.ErrorActionData.ViewModel(object: reponse.object, title: reponse.action.title)
        viewController?.displayErrorActionData(viewModel)
    }

    func presentSelectedErrorAction(_ response: ErrorModels.SelectErrorAction.Response) {
        let viewModel = ErrorModels.SelectErrorAction.ViewModel()
        switch response.action.option {
        case .close:
            viewController?.closeError(viewModel)
        case .solution:
            viewController?.performSolutionOnError(viewModel)
        }
    }
}
