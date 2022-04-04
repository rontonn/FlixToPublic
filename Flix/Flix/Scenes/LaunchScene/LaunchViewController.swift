//
//  
//  LaunchViewController.swift
//  FlixAR
//
//  Created by Anton Romanov on 12.10.2021.
//
//

import UIKit

protocol LaunchDisplayLogic: AnyObject {
    func displayTitle(_ viewModel: LaunchModels.InitialData.ViewModel)
}

final class LaunchViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private (set) weak var titleLabel: UILabel!

    // MARK: - Properties
    var interactor: LaunchBusinessLogic?
    var router: LaunchRouterable?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = LaunchModels.InitialData.Request()
        interactor?.requestPageTitle(request)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        routeToHome()
    }

    // MARK: - Private methods
    private func routeToHome() {
        router?.routeToHome()
    }
}

// MARK: - Conforming to LaunchDisplayLogic
extension LaunchViewController: LaunchDisplayLogic {
    func displayTitle(_ viewModel: LaunchModels.InitialData.ViewModel) {
        titleLabel.text = viewModel.pageTitle
    }
}
