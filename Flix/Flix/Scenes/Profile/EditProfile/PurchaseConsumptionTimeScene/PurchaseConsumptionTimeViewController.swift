//
//  
//  PurchaseConsumptionTimeViewController.swift
//  Flix
//
//  Created by Anton Romanov on 09.11.2021.
//
//

import UIKit

protocol PurchaseConsumptionTimeDisplayLogic: AnyObject {
    func displayPurchaseOptions(_ viewModel: PurchaseConsumptionTimeModels.InitialData.ViewModel)
    func displayPurchaseOption(_ viewModel: PurchaseConsumptionTimeModels.PurchaseConsumptionTimeOptionData.ViewModel)
    func displaySupplementaryView(_ viewModel: PurchaseConsumptionTimeModels.PurchaseConsumptionTimeSupplementaryViewData.ViewModel)
    func displaySelectedPurchaseOption(_ viewModel: PurchaseConsumptionTimeModels.SelectedPurchaseOption.ViewModel)
}

final class PurchaseConsumptionTimeViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var topContainerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var availableConsumptionTimeLabel: UILabel!
    @IBOutlet private weak var bottomDetailsLabel: UILabel!
    
    // MARK: - Properties
    var interactor: PurchaseConsumptionTimeBusinessLogic?
    var router: PurchaseConsumptionTimeRouterable?

    private var dataSource: UICollectionViewDiffableDataSource<UUID, UUID>?
    private (set) var collectionView: UICollectionView?
    private var prefferedSceneTabIndexPath: IndexPath = IndexPath(item: 0, section: 0)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()

        let request = PurchaseConsumptionTimeModels.InitialData.Request()
        interactor?.fetchPurchaseOptions(request)
    }
}

// MARK: - Private methods
private extension PurchaseConsumptionTimeViewController {
    func configure() {
        view.backgroundColor = .black
        titleLabel.text = "get_more_watching_time_title".localized
        titleLabel.textColor = .white
        subtitleLabel.text = "available_consumption_time_title".localized
        subtitleLabel.textColor = .white.withAlphaComponent(0.8)
        subtitleLabel.font = .jakarta(font: .display, ofSize: 27, weight: .regular)
        bottomDetailsLabel.text = "purchase_consumption_time_reward_note".localized
        bottomDetailsLabel.textColor = .white.withAlphaComponent(0.5)
    }

    func configureHierarchy(_ layout: UICollectionViewLayout) {
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
        configureSections()
    }

    func configureSections() {
        guard let collectionView = collectionView  else {
            return
        }
        collectionView.remembersLastFocusedIndexPath = true
        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: 67),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 770),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    func configureDataSource(_ viewModel: PurchaseConsumptionTimeModels.InitialData.ViewModel) {
        guard let collectionView = collectionView else {
            print("\(String(describing: PurchaseConsumptionTimeViewController.self)): Failed to get collection view.")
            return
        }
        let cellRegistration = UICollectionView.CellRegistration<PurchaseConsumptionTimeCell, UUID>.init(cellNib: PurchaseConsumptionTimeCell.cellNibName) { [weak self] cell, indexPath, id in
            let request = PurchaseConsumptionTimeModels.PurchaseConsumptionTimeOptionData.Request(object: cell, indexPath: indexPath)
            self?.interactor?.fetchPurchaseOption(request)
        }
        let headerRegistration = UICollectionView.SupplementaryRegistration<PurchaseConsumptionTimeSupplementaryView>.init(supplementaryNib: PurchaseConsumptionTimeSupplementaryView.cellNibName, elementKind: SupplementaryElementKind.sectionHeader) { [weak self] supplementaryView, elementKind, indexPath in
            let request = PurchaseConsumptionTimeModels.PurchaseConsumptionTimeSupplementaryViewData.Request(object: supplementaryView, indexPath: indexPath)
            self?.interactor?.fetchSupplementaryView(request)
        }
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemID in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemID)
        })
        dataSource?.supplementaryViewProvider = { (view, kind, index) in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration,
                                                                         for: index)
        }
        dataSource?.apply(viewModel.dataSourceSnapshot, animatingDifferences: false)
    }
}

// MARK: - UICollectionViewDelegate
extension PurchaseConsumptionTimeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let request = PurchaseConsumptionTimeModels.SelectedPurchaseOption.Request(indexPath: indexPath)
        interactor?.didSelectPurchaseOption(request)
    }

    func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {
        return prefferedSceneTabIndexPath
    }

    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        prefferedSceneTabIndexPath = indexPath
        return true
    }
}

// MARK: - PurchaseConsumptionTimeDisplayLogic
extension PurchaseConsumptionTimeViewController: PurchaseConsumptionTimeDisplayLogic {
    func displayPurchaseOptions(_ viewModel: PurchaseConsumptionTimeModels.InitialData.ViewModel) {
        availableConsumptionTimeLabel.text = viewModel.availableConsumptionTime
        availableConsumptionTimeLabel.font = .jakarta(font: .display, ofSize: 40, weight: .bold)
        availableConsumptionTimeLabel.textColor = .white
        configureHierarchy(viewModel.layout)
        configureDataSource(viewModel)
    }

    func displayPurchaseOption(_ viewModel: PurchaseConsumptionTimeModels.PurchaseConsumptionTimeOptionData.ViewModel) {
        guard let cell = viewModel.object as? PurchaseConsumptionTimeCell else {
            return
        }
        cell.setup(viewModel.option)
    }

    func displaySupplementaryView(_ viewModel: PurchaseConsumptionTimeModels.PurchaseConsumptionTimeSupplementaryViewData.ViewModel) {
        guard let supplementaryView = viewModel.object as? PurchaseConsumptionTimeSupplementaryView else {
            return
        }
        supplementaryView.setup(viewModel.header)
    }

    func displaySelectedPurchaseOption(_ viewModel: PurchaseConsumptionTimeModels.SelectedPurchaseOption.ViewModel) {
        router?.routeToConfirmConsumptionTimePurchaseScene()
    }
}
