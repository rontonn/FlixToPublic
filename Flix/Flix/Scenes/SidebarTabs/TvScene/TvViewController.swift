//
//  
//  TvViewController.swift
//  Flix
//
//  Created by Anton Romanov on 15.10.2021.
//
//

import UIKit

protocol TvDisplayLogic: AnyObject {
    func displayTvSections(_ viewModel: TvModels.InitialData.ViewModel)
    func displayTvBroadcastsHeaderItem(_ viewModel: TvModels.TvItemData.ViewModel)
    func displayTvBroadcastsItem(_ viewModel: TvModels.TvItemData.ViewModel)
    func displayTvChannelsHeaderItem(_ viewModel: TvModels.TvItemData.ViewModel)
    func displayTvChannelsItem(_ viewModel: TvModels.TvItemData.ViewModel)
    func setTvCollectionPosition(_ viewModel: TvModels.FocusChangedInTvCollection.ViewModel)
    func notifyHomeSceneToShowSidebar(_ viewModel: TvModels.FocusChangedInTvCollection.ViewModel)
    func notifyHomeSceneToHideSidebar(_ viewModel: TvModels.FocusChangedInTvCollection.ViewModel)
    func displaySelectedTvItem(_ viewModel: TvModels.SelectTvItem.ViewModel)
}

final class TvViewController: UIViewController {
    // MARK: - Properties
    var interactor: TvBusinessLogic?
    var router: TvRouterable?
    weak var homeSidebarAppearanceDelegate: HomeSidebarAppearance?

    private var dataSource: UICollectionViewDiffableDataSource<UUID, UUID>?
    private var collectionView: UICollectionView?
    private var prefferedSceneTabIndexPath: IndexPath = IndexPath(item: 0, section: 0)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = TvModels.InitialData.Request()
        interactor?.fetchTvCategories(request)
    }
}

// MARK: - Private methods
private extension TvViewController {
    func configureHierarchy(_ viewModel: TvModels.InitialData.ViewModel) {
        collectionView = UICollectionView(frame: CGRect(x: viewModel.leadingPadding,
                                                        y: 0,
                                                        width: view.bounds.width,
                                                        height: view.bounds.height),
                                          collectionViewLayout: viewModel.layout)
        configureTvSections()
    }

    func configureTvSections() {
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

    func configureDataSource(_ viewModel: TvModels.InitialData.ViewModel) {
        guard let collectionView = collectionView else {
            print("\(String(describing: TvViewController.self)): Failed to get collection view.")
            return
        }
        let tvBroadcastsCellRegistration = UICollectionView.CellRegistration<TvBroadcastCell, UUID>.init(cellNib: TvBroadcastCell.cellNibName) { [weak self] cell, indexPath, id in
            let request = TvModels.TvItemData.Request(object: cell, indexPath: indexPath)
            self?.interactor?.fetchTvBroadcastsItem(request)
        }
        let tvChannelsCellRegistration = UICollectionView.CellRegistration<TvChannelCell, UUID>.init(cellNib: TvChannelCell.cellNibName) { [weak self] cell, indexPath, id in
            let request = TvModels.TvItemData.Request(object: cell, indexPath: indexPath)
            self?.interactor?.fetchTvChannelsItem(request)
        }
        let tvBroadcastsHeaderRegistration = UICollectionView.SupplementaryRegistration<LiveBroadcastsSupplementaryView>.init(supplementaryNib: LiveBroadcastsSupplementaryView.cellNibName, elementKind: SupplementaryElementKind.sectionHeader) { [weak self] supplementaryView, elementKind, indexPath in
            let request = TvModels.TvItemData.Request(object: supplementaryView, indexPath: indexPath)
            self?.interactor?.fetchTvBroadcastsHeaderItem(request)
        }
        let headerRegistration = UICollectionView.SupplementaryRegistration<TitleSupplementaryView>(elementKind: SupplementaryElementKind.sectionHeader) { [weak self] supplementaryView, elementKind, indexPath in
            let request = TvModels.TvItemData.Request(object: supplementaryView, indexPath: indexPath)
            self?.interactor?.fetchTvChannelsHeaderItem(request)
        }
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, id in
            if indexPath.section == 0 {
                return collectionView.dequeueConfiguredReusableCell(using: tvBroadcastsCellRegistration, for: indexPath, item: id)
            } else {
                return collectionView.dequeueConfiguredReusableCell(using: tvChannelsCellRegistration, for: indexPath, item: id)
            }
        })
        dataSource?.supplementaryViewProvider = { (view, kind, index) in
            if index.section == 0 {
                return collectionView.dequeueConfiguredReusableSupplementary(using: tvBroadcastsHeaderRegistration,
                                                                             for: index)
            } else {
                return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration,
                                                                             for: index)
            }
        }
        dataSource?.apply(viewModel.dataSourceSnapshot, animatingDifferences: false)
    }
}

// MARK: - UICollectionViewDelegate
extension TvViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let request = TvModels.SelectTvItem.Request(indexPath: indexPath)
        interactor?.didSelectTvItem(request)
    }

    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        var nextIndexPath: IndexPath?
        if context.previouslyFocusedItem as? TvChannelCell != nil,
           let nextFocusedItem = context.nextFocusedItem as? TvChannelCell,
           let indexPath = collectionView.indexPath(for: nextFocusedItem) {
            nextIndexPath = indexPath
        } else if context.previouslyFocusedItem as? TvBroadcastCell != nil,
           let nextFocusedItem = context.nextFocusedItem as? TvBroadcastCell,
           let indexPath = collectionView.indexPath(for: nextFocusedItem) {
            nextIndexPath = indexPath
        }
        if let nextIndexPath = nextIndexPath {
            let request = TvModels.FocusChangedInTvCollection.Request(nextIndexPath: nextIndexPath)
            interactor?.focusChangedInTvCollection(request)
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

// MARK: - Conforming to TvDisplayLogic
extension TvViewController: TvDisplayLogic {
    func displayTvSections(_ viewModel: TvModels.InitialData.ViewModel) {
        configureHierarchy(viewModel)
        configureDataSource(viewModel)
    }

    func displayTvBroadcastsHeaderItem(_ viewModel: TvModels.TvItemData.ViewModel) {
        if let tvBroadcastsSectionHeader = viewModel.tvBroadcastsSectionHeader, let headerView = viewModel.object as? LiveBroadcastsSupplementaryView {
            headerView.setup(tvBroadcastsSectionHeader)
        }
    }

    func displayTvBroadcastsItem(_ viewModel: TvModels.TvItemData.ViewModel) {
        if let tvBroadcastItem = viewModel.tvBroadcastItem, let cell = viewModel.object as? TvBroadcastCell {
            cell.setTvBroadcast(tvBroadcastItem)
        }
    }

    func displayTvChannelsHeaderItem(_ viewModel: TvModels.TvItemData.ViewModel) {
        if let categoryTile = viewModel.categoryTile, let headerView = viewModel.object as? TitleSupplementaryView {
            headerView.setTitle(categoryTile)
        }
    }

    func displayTvChannelsItem(_ viewModel: TvModels.TvItemData.ViewModel) {
        if let tvChannelItem = viewModel.tvChannelItem, let cell = viewModel.object as? TvChannelCell {
            cell.setChannel(tvChannelItem)
        }
    }

    func setTvCollectionPosition(_ viewModel: TvModels.FocusChangedInTvCollection.ViewModel) {
        guard let collectionView = collectionView, let leadingPadding = viewModel.leadingPadding else {
            return
        }
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseInOut], animations: {
            collectionView.frame = CGRect(x: leadingPadding,
                                          y: collectionView.frame.origin.y,
                                          width: self.view.bounds.width,
                                          height: self.view.bounds.height)
            self.view.layoutIfNeeded()
        })
    }

    func notifyHomeSceneToShowSidebar(_ viewModel: TvModels.FocusChangedInTvCollection.ViewModel) {
        let request = HomeModels.SideBarAppearance.Request()
        homeSidebarAppearanceDelegate?.showHomeSidebar(request)
    }

    func notifyHomeSceneToHideSidebar(_ viewModel: TvModels.FocusChangedInTvCollection.ViewModel) {
        let request = HomeModels.SideBarAppearance.Request()
        homeSidebarAppearanceDelegate?.hideHomeSideBar(request)
    }

    func displaySelectedTvItem(_ viewModel: TvModels.SelectTvItem.ViewModel) {
    }
}
