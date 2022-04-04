//
//  
//  ErrorViewController.swift
//  Flix
//
//  Created by Anton Romanov on 29.10.2021.
//
//

import UIKit

protocol ErrorDisplayLogic: AnyObject {
    func displayError(_ viewModel: ErrorModels.InitialData.ViewModel)
    func displayErrorActionData(_ viewModel: ErrorModels.ErrorActionData.ViewModel)
    func closeError(_ viewModel: ErrorModels.SelectErrorAction.ViewModel)
    func performSolutionOnError(_ viewModel: ErrorModels.SelectErrorAction.ViewModel)
}

final class ErrorViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var errorImageView: UIImageView!
    
    // MARK: - Properties
    var interactor: ErrorBusinessLogic?
    var router: ErrorRouterable?

    private var dataSource: UICollectionViewDiffableDataSource<UUID, UUID>?
    private var collectionView: UICollectionView?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = ErrorModels.InitialData.Request()
        interactor?.fetchErrorInfo(request)
    }
}

// MARK: - Private methods
private extension ErrorViewController {
    func configureHierarchy(_ layout: UICollectionViewLayout) {
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
        
        if let collectionView = collectionView {
            collectionView.delegate = self
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            collectionView.backgroundColor = .clear
            collectionView.clipsToBounds = false
            view.addSubview(collectionView)

            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 36),
                collectionView.widthAnchor.constraint(equalToConstant: 292),
                collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 30)
            ])
        }
    }

    func configureDataSource(_ viewModel: ErrorModels.InitialData.ViewModel) {
        guard let collectionView = collectionView else {
            print("\(String(describing: ErrorViewController.self)): Failed to get collection view.")
            return
        }
        let cellRegistration = UICollectionView.CellRegistration<TextCell, UUID> { [weak self] cell, indexPath, id in
            let request = ErrorModels.ErrorActionData.Request(object: cell, indexPath: indexPath)
            self?.interactor?.fetchErrorActionData(request)
        }

        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemID in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemID)
        })

        dataSource?.apply(viewModel.dataSourceSnapshot, animatingDifferences: false)
    }
}

// MARK: - Conforming to ErrorDisplayLogic
extension ErrorViewController: ErrorDisplayLogic {
    func displayError(_ viewModel: ErrorModels.InitialData.ViewModel) {
        errorLabel.text = viewModel.description
        errorImageView.image = viewModel.image
        configureHierarchy(viewModel.layout)
        configureDataSource(viewModel)
    }

    func displayErrorActionData(_ viewModel: ErrorModels.ErrorActionData.ViewModel) {
        guard let cell = viewModel.object as? TextCell else {
            return
        }
        cell.setTitle(viewModel.title)
    }

    func closeError(_ viewModel: ErrorModels.SelectErrorAction.ViewModel) {
        dismiss(animated: true)
    }

    func performSolutionOnError(_ viewModel: ErrorModels.SelectErrorAction.ViewModel) {
    }
}

// MARK: - UICollectionViewDelegate
extension ErrorViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let request = ErrorModels.SelectErrorAction.Request(indexPath: indexPath)
        interactor?.didSelectErrorAction(request)
    }
}
