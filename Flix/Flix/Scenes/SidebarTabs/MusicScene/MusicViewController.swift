//
//  
//  MusicViewController.swift
//  Flix
//
//  Created by Anton Romanov on 15.10.2021.
//
//

import UIKit

protocol MusicDisplayLogic: AnyObject {
    func displayMusicSections(_ viewModel: MusicModels.InitialData.ViewModel)
    func displayMusicItem(_ viewModel: MusicModels.MusicItemData.ViewModel)
    func displayMusicSectionHeader(_ viewModel: MusicModels.MusicItemData.ViewModel)
    func setMusicCollectionPosition(_ viewModel: MusicModels.FocusChangedInMusicCollection.ViewModel)
    func notifyHomeSceneToShowSidebar(_ viewModel: MusicModels.FocusChangedInMusicCollection.ViewModel)
    func notifyHomeSceneToHideSidebar(_ viewModel: MusicModels.FocusChangedInMusicCollection.ViewModel)
    func displaySelectedMusic(_ viewModel: MusicModels.SelectMusic.ViewModel)
}

final class MusicViewController: UIViewController {
    // MARK: - Properties
    var interactor: MusicBusinessLogic?
    var router: MusicRouterable?
    weak var homeSidebarAppearanceDelegate: HomeSidebarAppearance?

    private var dataSource: UICollectionViewDiffableDataSource<UUID, UUID>?
    private var collectionView: UICollectionView?
    private var prefferedSceneTabIndexPath: IndexPath = IndexPath(item: 0, section: 0)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = MusicModels.InitialData.Request()
        interactor?.fetchMusicCategories(request)
    }
}

// MARK: - Private methods
private extension MusicViewController {
    func configureHierarchy(_ viewModel: MusicModels.InitialData.ViewModel) {
        collectionView = UICollectionView(frame: CGRect(x: viewModel.leadingPadding,
                                                        y: 0,
                                                        width: view.bounds.width,
                                                        height: view.bounds.height),
                                          collectionViewLayout: viewModel.layout)
        configureMusicSections()
    }
    func configureMusicSections() {
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
    func configureDataSource(_ viewModel: MusicModels.InitialData.ViewModel) {
        guard let collectionView = collectionView else {
            print("\(String(describing: MusicViewController.self)): Failed to get collection view.")
            return
        }
        let cellRegistration = UICollectionView.CellRegistration<MusicCell, UUID>.init(cellNib: MusicCell.cellNibName) { [weak self] cell, indexPath, id in
            let request = MusicModels.MusicItemData.Request(object: cell, indexPath: indexPath)
            self?.interactor?.fetchMusicItem(request)
        }
        let headerRegistration = UICollectionView.SupplementaryRegistration<TitleSupplementaryView>(elementKind: SupplementaryElementKind.sectionHeader) { [weak self] supplementaryView, elementKind, indexPath in
            let request = MusicModels.MusicItemData.Request(object: supplementaryView, indexPath: indexPath)
            self?.interactor?.fetchMusicSectionHeader(request)
        }
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, id in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: id)
        })
        dataSource?.supplementaryViewProvider = { (view, kind, index) in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration,
                                                                         for: index)
        }
        dataSource?.apply(viewModel.dataSourceSnapshot, animatingDifferences: false)
    }
}

// MARK: - UICollectionViewDelegate
extension MusicViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let request = MusicModels.SelectMusic.Request(indexPath: indexPath)
        interactor?.didSelectMusic(request)
    }

    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if context.previouslyFocusedItem as? MusicCell != nil,
           let nextFocusedItem = context.nextFocusedItem as? MusicCell,
           let indexPath = collectionView.indexPath(for: nextFocusedItem) {
            let request = MusicModels.FocusChangedInMusicCollection.Request(nextIndexPath: indexPath)
            interactor?.focusChangedInMusicCollection(request)
        }
    }

    func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {
        return prefferedSceneTabIndexPath
    }

    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        prefferedSceneTabIndexPath = indexPath
        return true
    }
}

// MARK: - Conforming to MusicDisplayLogic
extension MusicViewController: MusicDisplayLogic {
    func displayMusicSections(_ viewModel: MusicModels.InitialData.ViewModel) {
        configureHierarchy(viewModel)
        configureDataSource(viewModel)
    }

    func displayMusicItem(_ viewModel: MusicModels.MusicItemData.ViewModel) {
        guard let cell = viewModel.object as? MusicCell, let musicItem = viewModel.musicItem else {
            return
        }
        cell.setMusic(musicItem)
    }

    func displayMusicSectionHeader(_ viewModel: MusicModels.MusicItemData.ViewModel) {
        guard let headerView = viewModel.object as? TitleSupplementaryView, let categoryTitle = viewModel.categoryTile else {
            return
        }
        headerView.setTitle(categoryTitle)
    }

    func setMusicCollectionPosition(_ viewModel: MusicModels.FocusChangedInMusicCollection.ViewModel) {
        guard let leadingPadding = viewModel.leadingPadding else {
            return
        }
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseInOut], animations: {
            self.collectionView?.frame = CGRect(x: leadingPadding,
                                                y: 0,
                                                width: self.view.bounds.width,
                                                height: self.view.bounds.height)
            self.view.layoutIfNeeded()
        })
    }

    func notifyHomeSceneToShowSidebar(_ viewModel: MusicModels.FocusChangedInMusicCollection.ViewModel) {
        let request = HomeModels.SideBarAppearance.Request()
        homeSidebarAppearanceDelegate?.showHomeSidebar(request)
    }

    func notifyHomeSceneToHideSidebar(_ viewModel: MusicModels.FocusChangedInMusicCollection.ViewModel) {
        let request = HomeModels.SideBarAppearance.Request()
        homeSidebarAppearanceDelegate?.hideHomeSideBar(request)
    }

    func displaySelectedMusic(_ viewModel: MusicModels.SelectMusic.ViewModel) {
    }
}
