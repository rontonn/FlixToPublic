//
//  
//  SignInWalletInteractor.swift
//  Flix
//
//  Created by Anton Romanov on 14.10.2021.
//
//

import Foundation

protocol SignInWalletBusinessLogic {
    func provideInitialData(_ request: SignInWalletModels.InitialData.Request)
}

protocol SignInWalletDataStore {
}

final class SignInWalletInteractor: SignInWalletDataStore {
    // MARK: - Properties
    var presenter: SignInWalletPresentationLogic?
    var qrCodeWorker: QRCodeWorkerWorkerLogic?

    // MARK: - Lifecycle
    init() {
        AccountsWorker.shared.connect()
        if let context = AccountsWorker.shared.connectionURL {
            qrCodeWorker = QRCodeWorker(context: context,
                                        scaleX: 5,
                                        scaleY: 5)
        }
    }
}

// MARK: - SignInWalletBusinessLogic
extension SignInWalletInteractor: SignInWalletBusinessLogic {
    func provideInitialData(_ request: SignInWalletModels.InitialData.Request) {
        let qrImage = qrCodeWorker?.qrCodeImage()
        let response = SignInWalletModels.InitialData.Response(pageTitle: "sign_in_wallet_page_title".localized,
                                                               qrImage: qrImage)
        presenter?.presentInitialData(response)
    }
}
