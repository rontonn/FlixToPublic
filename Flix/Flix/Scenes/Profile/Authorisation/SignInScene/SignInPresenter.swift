//
//  
//  SignInPresenter.swift
//  FlixAR
//
//  Created by Anton Romanov on 13.10.2021.
//
//
import UIKit

protocol SignInPresentationLogic {
    func presentSignInOptions(_ response: SignInModels.InitialData.Response)
    func presentSignInOption(_ response: SignInModels.SignInOptionData.Response)
    func presentSelectedSignInOption(_ response: SignInModels.SelectSignInOption.Response)
}

final class SignInPresenter {
    // MARK: - Properties
    weak var viewController: SignInDisplayLogic?

    private let signInOptionsSectionUUID = UUID()
}

// MARK: - SignInPresentationLogic
extension SignInPresenter: SignInPresentationLogic {
    func presentSignInOptions(_ response: SignInModels.InitialData.Response) {
        let signInCollectionLayoutSource = SignInCollectionLayoutSource()
        let layout = signInCollectionLayoutSource.createLayout()

        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        snapshot.appendSections([signInOptionsSectionUUID])
        let uuids = response.signInOptions.map { $0.id }
        snapshot.appendItems(uuids)
        let viewModel = SignInModels.InitialData.ViewModel(pageTitle: "flix_slogan_title".localized,
                                                           dataSourceSnapshot: snapshot,
                                                           layout: layout)
        viewController?.displaySignInOptions(viewModel)
    }

    func presentSignInOption(_ response: SignInModels.SignInOptionData.Response) {
        let viewModel = SignInModels.SignInOptionData.ViewModel(object: response.object, signInOption: response.signInOption)
        viewController?.displaySignInOption(viewModel)
    }

    func presentSelectedSignInOption(_ response: SignInModels.SelectSignInOption.Response) {
        let viewModel = SignInModels.SelectSignInOption.ViewModel()
        switch response.option {
        case .qr:
            viewController?.displaySignInWithQR(viewModel)
        case .wallet:
            viewController?.displaySignInWithWallet(viewModel)
        }
    }
}
