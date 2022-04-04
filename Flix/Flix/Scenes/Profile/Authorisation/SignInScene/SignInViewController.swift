//
//  
//  SignInViewController.swift
//  FlixAR
//
//  Created by Anton Romanov on 13.10.2021.
//
//

import UIKit

protocol SignInDisplayLogic: AnyObject {
    func displaySignInOptions(_ viewModel: SignInModels.InitialData.ViewModel)
    func displaySignInOption(_ viewModel: SignInModels.SignInOptionData.ViewModel)
    func displaySignInWithWallet(_ viewModel: SignInModels.SelectSignInOption.ViewModel)
    func displaySignInWithQR(_ viewModel: SignInModels.SelectSignInOption.ViewModel)
}

final class SignInViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - Properties
    var interactor: SignInBusinessLogic?
    var router: SignInRouterable?

    private var dataSource: UICollectionViewDiffableDataSource<UUID, UUID>?
    private var collectionView: UICollectionView?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = SignInModels.InitialData.Request()
        interactor?.fetchSignInOptions(request)
    }
}

// MARK: - Private methods
private extension SignInViewController {
    func configureHierarchy(_ layout: UICollectionViewLayout) {
        collectionView = UICollectionView(frame: CGRect(x: 764,
                                                        y: 620,
                                                        width: 359,
                                                        height: 254),
                                          collectionViewLayout: layout)
        
        if let collectionView = collectionView {
            collectionView.delegate = self
            collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            collectionView.backgroundColor = .clear
            collectionView.clipsToBounds = false
            view.addSubview(collectionView)
        }
    }

    func configureDataSource(_ viewModel: SignInModels.InitialData.ViewModel) {
        guard let collectionView = collectionView else {
            print("\(String(describing: SignInViewController.self)): Failed to get collection view.")
            return
        }
        let cellRegistration = UICollectionView.CellRegistration<TextCell, UUID> { [weak self] cell, indexPath, id in
            let request = SignInModels.SignInOptionData.Request(object: cell, indexPath: indexPath)
            self?.interactor?.fetchSignInOption(request)
        }

        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemID in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemID)
        })

        dataSource?.apply(viewModel.dataSourceSnapshot, animatingDifferences: false)
    }
}

// MARK: - Conforming to SignInDisplayLogic
extension SignInViewController: SignInDisplayLogic {
    func displaySignInOptions(_ viewModel: SignInModels.InitialData.ViewModel) {
        titleLabel.text = viewModel.pageTitle
        configureHierarchy(viewModel.layout)
        configureDataSource(viewModel)
    }

    func displaySignInOption(_ viewModel: SignInModels.SignInOptionData.ViewModel) {
        guard let cell = viewModel.object as? TextCell else {
            return
        }
        cell.setTitle(viewModel.signInOption.title)
    }

    func displaySignInWithWallet(_ viewModel: SignInModels.SelectSignInOption.ViewModel) {
        router?.routeToSigInWallet()
    }

    func displaySignInWithQR(_ viewModel: SignInModels.SelectSignInOption.ViewModel) {
    }
}

// MARK: - UICollectionViewDelegate
extension SignInViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let request = SignInModels.SelectSignInOption.Request(indexPath: indexPath)
        interactor?.didSelectSignInOption(request)
    }
}
