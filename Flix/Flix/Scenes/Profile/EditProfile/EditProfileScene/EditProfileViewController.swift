//
//  
//  EditProfileViewController.swift
//  Flix
//
//  Created by Anton Romanov on 03.11.2021.
//
//
import UIKit

protocol EditProfileDisplayLogic: AnyObject {
    func displayEditProfileOptions(_ viewModel: EditProfileModels.InitialData.ViewModel)
    func displayEditProfileOption(_ viewModel: EditProfileModels.CollectionData.ViewModel)
    func displayUpdatedEditProfileOptions(_ viewModel: EditProfileModels.UpdatedData.ViewModel)
    func displayEditName(_ viewModel: EditProfileModels.FocusUpdated.ViewModel)
    func displayEditProfileImageScene(_ viewModel: EditProfileModels.FocusUpdated.ViewModel)
    func displayEditConsumptionTimeScene(_ viewModel: EditProfileModels.FocusUpdated.ViewModel)
}

final class EditProfileViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private (set) weak var editOptionContainerView: UIView!

    // MARK: - Properties
    var interactor: EditProfileBusinessLogic?
    var router: EditProfileRouterable?

    private var dataSource: UICollectionViewDiffableDataSource<UUID, UUID>?
    private (set) var collectionView: UICollectionView?
    private var prefferedOptionIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    private let editProfileOptionsVerticalFocusGuide = UIFocusGuide()

    var update = false

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = EditProfileModels.InitialData.Request()
        interactor?.fetchEditProfileOptions(request)
        addEditProfileOptionsFocusGuide()
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        coordinator.addCoordinatedAnimations {
        } completion: {
            if (context.nextFocusedItem as? EditProfileOptionCell) != nil {
                self.editProfileOptionsVerticalFocusGuide.preferredFocusEnvironments = [self.editOptionContainerView]
            } else {
                self.editProfileOptionsVerticalFocusGuide.preferredFocusEnvironments = []
            }
        }
    }
}

// MARK: - Private methods
private extension EditProfileViewController {
    func addEditProfileOptionsFocusGuide() {
        view.addLayoutGuide(editProfileOptionsVerticalFocusGuide)
        NSLayoutConstraint.activate([
            editProfileOptionsVerticalFocusGuide.topAnchor.constraint(equalTo: view.topAnchor),
            editProfileOptionsVerticalFocusGuide.rightAnchor.constraint(equalTo: editOptionContainerView.leftAnchor),
            editProfileOptionsVerticalFocusGuide.widthAnchor.constraint(equalToConstant: 10),
            editProfileOptionsVerticalFocusGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func configureHierarchy(_ viewModel: EditProfileModels.InitialData.ViewModel) {
        collectionView = UICollectionView(frame: CGRect(x: viewModel.leadingPadding,
                                                        y: viewModel.topPadding,
                                                        width: 544,
                                                        height: view.bounds.height - viewModel.leadingPadding),
                                          collectionViewLayout: viewModel.layout)
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
        view.addSubview(collectionView)
    }

    func configureDataSource(_ viewModel: EditProfileModels.InitialData.ViewModel) {
        guard let collectionView = collectionView else {
            print("\(String(describing: EditProfileViewController.self)): Failed to get collection view.")
            return
        }
        let cellRegistration = UICollectionView.CellRegistration<EditProfileOptionCell, UUID>.init(cellNib: EditProfileOptionCell.cellNibName) { [weak self] cell, indexPath, id in
            let request = EditProfileModels.CollectionData.Request(object: cell, indexPath: indexPath)
            self?.interactor?.fetchEditProfileOption(request)
        }
        let headerRegistration = UICollectionView.SupplementaryRegistration<TitleSupplementaryView>(elementKind: SupplementaryElementKind.sectionHeader) { supplementaryView, elementKind, indexPath in
            let title = EditProfileData.title
            supplementaryView.setTitle(title,
                                       font: .jakarta(font: .display,
                                                      ofSize: 44,
                                                      weight: .bold))
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
extension EditProfileViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {
        return prefferedOptionIndexPath
    }
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        prefferedOptionIndexPath = indexPath
        return true
    }
}

// MARK: - Conforming to EditProfileDisplayLogic
extension EditProfileViewController: EditProfileDisplayLogic {
    func displayEditProfileOptions(_ viewModel: EditProfileModels.InitialData.ViewModel) {
        configureHierarchy(viewModel)
        configureDataSource(viewModel)
    }

    func displayEditProfileOption(_ viewModel: EditProfileModels.CollectionData.ViewModel) {
        guard let cell = viewModel.object as? EditProfileOptionCell else {
            return
        }
        cell.setEdit(viewModel.editProfileData, delegate: self)
    }

    func displayUpdatedEditProfileOptions(_ viewModel: EditProfileModels.UpdatedData.ViewModel) {
        guard var currentSnapshot = dataSource?.snapshot() else {
            return
        }
        let oldUUIDS = currentSnapshot.itemIdentifiers(inSection: viewModel.section)
        currentSnapshot.reconfigureItems(oldUUIDS)
        dataSource?.apply(currentSnapshot, animatingDifferences: true)
    }

    func displayEditName(_ viewModel: EditProfileModels.FocusUpdated.ViewModel) {
        router?.routeToEditName()
    }

    func displayEditProfileImageScene(_ viewModel: EditProfileModels.FocusUpdated.ViewModel) {
        router?.routeToEditProfileImageScene()
    }

    func displayEditConsumptionTimeScene(_ viewModel: EditProfileModels.FocusUpdated.ViewModel) {
        router?.routeToEditConsumptionTimeScene()
    }
}

// MARK: - SceneTabCellDelegate
extension EditProfileViewController: EditProfileOptionCellDelegate {
    func focusUpdated(to editProfileData: EditProfileData?) {
        let request = EditProfileModels.FocusUpdated.Request(editProfileData: editProfileData)
        interactor?.didUpdateFocus(request)
    }
}
