//
//  
//  EditProfileImageViewController.swift
//  Flix
//
//  Created by Anton Romanov on 08.11.2021.
//
//

import UIKit

protocol EditProfileImageDisplayLogic: AnyObject {
    func displayEditProfileImageOptions(_ viewModel: EditProfileImageModels.InitialData.ViewModel)
    func displayEditProfileImageOption(_ viewModel: EditProfileImageModels.CollectionData.ViewModel)
}

final class EditProfileImageViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var profileImageView: UIImageView!
    
    // MARK: - Properties
    var interactor: EditProfileImageBusinessLogic?
    var router: EditProfileImageRouterable?

    private var dataSource: UICollectionViewDiffableDataSource<UUID, UUID>?
    private (set) var collectionView: UICollectionView?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProfileImage()

        let request = EditProfileImageModels.InitialData.Request()
        interactor?.fetchEditProfileImageOptions(request)
    }
}

// MARK: - Private methods
private extension EditProfileImageViewController {
    func setupProfileImage() {
        profileImageView.isHidden = true
    }

    func configureHierarchy(_ viewModel: EditProfileImageModels.InitialData.ViewModel) {
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: viewModel.layout)
        configureSections(topPadding: viewModel.topPadding)
    }

    func configureSections(topPadding: CGFloat) {
        guard let collectionView = collectionView  else {
            return
        }
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.remembersLastFocusedIndexPath = true
        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = false
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: topPadding),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10),
            collectionView.widthAnchor.constraint(equalToConstant: 339)
        ])
    }
    func configureDataSource(_ viewModel: EditProfileImageModels.InitialData.ViewModel) {
        guard let collectionView = collectionView else {
            print("\(String(describing: EditProfileImageViewController.self)): Failed to get collection view.")
            return
        }
        let cellRegistration = UICollectionView.CellRegistration<TextCell, UUID> { [weak self] cell, indexPath, id in
            let request = EditProfileImageModels.CollectionData.Request(object: cell, indexPath: indexPath)
            self?.interactor?.fetchEditProfileImageOption(request)
        }
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemID in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemID)
        })
        dataSource?.apply(viewModel.dataSourceSnapshot, animatingDifferences: false)
    }
}

// MARK: - UICollectionViewDelegate
extension EditProfileImageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK: - Conforming to EditProfileDisplayLogic
extension EditProfileImageViewController: EditProfileImageDisplayLogic {
    func displayEditProfileImageOptions(_ viewModel: EditProfileImageModels.InitialData.ViewModel) {
        configureHierarchy(viewModel)
        configureDataSource(viewModel)
        profileImageView.image = #imageLiteral(resourceName: "defaultProfileImage")
        if let profileImage = viewModel.profileImage {
            Task {
                if let profileImage = try? await ImageLoadingWorker.fetchImage(profileImage) {
                    profileImageView.image = profileImage
                }
                profileImageView.layer.borderColor = UIColor.white.cgColor
                profileImageView.layer.borderWidth = 6
                profileImageView.layer.cornerRadius = profileImageView.bounds.size.height / 2
                profileImageView.isHidden = false
            }
        }
    }

    func displayEditProfileImageOption(_ viewModel: EditProfileImageModels.CollectionData.ViewModel) {
        guard let cell = viewModel.object as? TextCell else {
            return
        }
        cell.setTitle(viewModel.editProfileImageOption.title)
    }
}
