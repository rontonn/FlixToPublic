//
//  
//  SignInWalletViewController.swift
//  Flix
//
//  Created by Anton Romanov on 14.10.2021.
//
//

import UIKit

protocol SignInWalletDisplayLogic: AnyObject {
    func displayInitialData(_ viewModel: SignInWalletModels.InitialData.ViewModel)
}

final class SignInWalletViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var qrCodeImageView: UIImageView!
    @IBOutlet private weak var labelTitle: UILabel!
    
    // MARK: - Properties
    var interactor: SignInWalletBusinessLogic?
    var router: SignInWalletRouterable?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        let request = SignInWalletModels.InitialData.Request()
        interactor?.provideInitialData(request)
    }
}

// MARK: - Private methods
private extension SignInWalletViewController {
    func configure() {
        qrCodeImageView.layer.cornerRadius = 30
    }
}

// MARK: - Conforming to SignInWalletDisplayLogic
extension SignInWalletViewController: SignInWalletDisplayLogic {
    func displayInitialData(_ viewModel: SignInWalletModels.InitialData.ViewModel) {
        labelTitle.text = viewModel.pageTitle
        qrCodeImageView.image = viewModel.qrImage
    }
}
