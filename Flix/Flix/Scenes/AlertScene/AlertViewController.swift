//
//  
//  AlertViewController.swift
//  Flix
//
//  Created by Anton Romanov on 11.11.2021.
//
//

import UIKit

protocol AlertDisplayLogic: AnyObject {
    func displayAlert(_ viewModel: AlertModels.InitialData.ViewModel)
    func displayAlertActionData(_ viewModel: AlertModels.AlertActionData.ViewModel)
    func closeAlert(_ viewModel: AlertModels.SelectAlertAction.ViewModel)
}

final class AlertViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var labelsStackView: UIStackView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    
    // MARK: - Properties
    var interactor: AlertBusinessLogic?
    var router: AlertRouterable?

    private var dataSource: UICollectionViewDiffableDataSource<UUID, UUID>?
    private var collectionView: UICollectionView?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

// MARK: - Private methods
private extension AlertViewController {
    func configure() {
        view.backgroundColor = .black
        let request = AlertModels.InitialData.Request()
        interactor?.fetchAlertData(request)
    }

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
                collectionView.topAnchor.constraint(equalTo: labelsStackView.bottomAnchor, constant: 56),
                collectionView.widthAnchor.constraint(equalToConstant: 380),
                collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 30)
            ])
        }
    }

    func configureDataSource(_ viewModel: AlertModels.InitialData.ViewModel) {
        guard let collectionView = collectionView else {
            print("\(String(describing: AlertViewController.self)): Failed to get collection view.")
            return
        }
        let cellRegistration = UICollectionView.CellRegistration<TextCell, UUID> { [weak self] cell, indexPath, id in
            let request = AlertModels.AlertActionData.Request(object: cell, indexPath: indexPath)
            self?.interactor?.fetchAlertActionData(request)
        }

        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemID in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemID)
        })

        dataSource?.apply(viewModel.dataSourceSnapshot, animatingDifferences: false)
    }
}

// MARK: - Conforming to AlertDisplayLogic
extension AlertViewController: AlertDisplayLogic {
    func displayAlert(_ viewModel: AlertModels.InitialData.ViewModel) {
        titleLabel.text = viewModel.info.title
        if let subtitle = viewModel.info.subtitle {
            subtitleLabel.text = subtitle
        } else {
            subtitleLabel.isHidden = true
        }
        if let image = viewModel.info.image {
            imageView.image = image
        } else {
            imageView.isHidden = true
        }
        configureHierarchy(viewModel.layout)
        configureDataSource(viewModel)
    }

    func displayAlertActionData(_ viewModel: AlertModels.AlertActionData.ViewModel) {
        guard let cell = viewModel.object as? TextCell else {
            return
        }
        cell.setTitle(viewModel.title)
    }

    func closeAlert(_ viewModel: AlertModels.SelectAlertAction.ViewModel) {
        dismiss(animated: true)
    }
}

// MARK: - UICollectionViewDelegate
extension AlertViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let request = AlertModels.SelectAlertAction.Request(indexPath: indexPath)
        interactor?.didSelectAlertAction(request)
    }
}
