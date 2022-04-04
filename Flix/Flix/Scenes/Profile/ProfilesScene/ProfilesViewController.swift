//
//  
//  ProfilesViewController.swift
//  Flix
//
//  Created by Anton Romanov on 02.11.2021.
//
//

import UIKit

protocol ProfilesDisplayLogic: AnyObject {
    func displayProfiles(_ viewModel: ProfilesModels.InitialData.ViewModel)
    func displayProfile(_ viewModel: ProfilesModels.ProfileData.ViewModel)
    func displayEditProfile(_ viewModel: ProfilesModels.EditProfile.ViewModel)
    func displayLoading(_ viewModel: ProfilesModels.EditProfile.ViewModel)
}

final class ProfilesViewController: UIViewController {
    // MARK: - Properties
    var interactor: ProfilesBusinessLogic?
    var router: ProfilesRouterable?

    private var dataSource: UICollectionViewDiffableDataSource<UUID, UUID>?
    private (set) var collectionView: UICollectionView?
    private var loadingSpinnerView: LoadingSpinnerView?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = ProfilesModels.InitialData.Request()
        interactor?.fetchProfiles(request)
    }
}

// MARK: - Private methods
private extension ProfilesViewController {
    func configureHierarchy(_ layout: UICollectionViewLayout) {
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
        
        if let collectionView = collectionView {
            collectionView.delegate = self
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.backgroundColor = .clear
            collectionView.clipsToBounds = false
            view.addSubview(collectionView)
            NSLayoutConstraint.activate([
                collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                collectionView.heightAnchor.constraint(equalToConstant: 337),
                collectionView.widthAnchor.constraint(equalToConstant: 500),
            ])
        }
    }

    func configureDataSource(_ viewModel: ProfilesModels.InitialData.ViewModel) {
        guard let collectionView = collectionView else {
            print("\(String(describing: ProfilesViewController.self)): Failed to get collection view.")
            return
        }
        let cellRegistration = UICollectionView.CellRegistration<ProfileCell, UUID> { [weak self] cell, indexPath, id in
            let request = ProfilesModels.ProfileData.Request(object: cell, indexPath: indexPath)
            self?.interactor?.fetchProfile(request)
        }

        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemID in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemID)
        })

        dataSource?.apply(viewModel.dataSourceSnapshot, animatingDifferences: false)
    }

    func showLoader() {
        loadingSpinnerView = LoadingSpinnerView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height),
                                                titles: nil)
        if let loadingSpinnerView = loadingSpinnerView {
            view.addSubview(loadingSpinnerView)
        }
        loadingSpinnerView?.startAnimating()
    }

    
    func hideLoader() {
        loadingSpinnerView?.stopAnimating()
        loadingSpinnerView?.removeFromSuperview()
        loadingSpinnerView = nil
    }
}

// MARK: - Conforming to ProfilesDisplayLogic
extension ProfilesViewController: ProfilesDisplayLogic {
    func displayProfiles(_ viewModel: ProfilesModels.InitialData.ViewModel) {
        configureHierarchy(viewModel.layout)
        configureDataSource(viewModel)
    }

    func displayProfile(_ viewModel: ProfilesModels.ProfileData.ViewModel) {
        guard let cell = viewModel.object as? ProfileCell else {
            return
        }
        cell.setContent(for: viewModel.profile)
    }

    func displayEditProfile(_ viewModel: ProfilesModels.EditProfile.ViewModel) {
        router?.routeToEditProfile()
    }

    func displayLoading(_ viewModel: ProfilesModels.EditProfile.ViewModel) {
        showLoader()
    }
}

// MARK: - UICollectionViewDelegate
extension ProfilesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let request = ProfilesModels.EditProfile.Request(indexPath: indexPath)
        interactor?.didSelectProfile(request)
    }
}
