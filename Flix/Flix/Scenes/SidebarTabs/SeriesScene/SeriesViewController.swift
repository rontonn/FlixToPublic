//
//  
//  SeriesViewController.swift
//  Flix
//
//  Created by Anton Romanov on 15.10.2021.
//
//

import UIKit

protocol SeriesDisplayLogic: AnyObject {
    func displaySeriesSecitons(_ viewModel: SeriesModels.InitialData.ViewModel)
    func displaySeries(_ viewModel: SeriesModels.SeriesData.ViewModel)
    func displaySeriesSectionHeader(_ viewModel: SeriesModels.SeriesData.ViewModel)
    func setSeriesCollectionPosition(_ viewModel: SeriesModels.FocusChangedInSeriesCollection.ViewModel)
    func notifyHomeSceneToShowSidebar(_ viewModel: SeriesModels.FocusChangedInSeriesCollection.ViewModel)
    func notifyHomeSceneToHideSidebar(_ viewModel: SeriesModels.FocusChangedInSeriesCollection.ViewModel)
    func displaySelectedSeries(_ viewModel: SeriesModels.SelectSeries.ViewModel)
}

final class SeriesViewController: UIViewController {
    // MARK: - Properties
    var interactor: SeriesBusinessLogic?
    var router: SeriesRouterable?
    weak var homeSidebarAppearanceDelegate: HomeSidebarAppearance?

    private var dataSource: UICollectionViewDiffableDataSource<UUID, UUID>?
    private var collectionView: UICollectionView?
    private var prefferedSceneTabIndexPath: IndexPath = IndexPath(item: 0, section: 0)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = SeriesModels.InitialData.Request()
        interactor?.fetchSeriesCategories(request)
    }
}

// MARK: - Private methods
private extension SeriesViewController {
    func configureHierarchy(_ viewModel: SeriesModels.InitialData.ViewModel) {
        collectionView = UICollectionView(frame: CGRect(x: viewModel.leadingPadding,
                                                        y: 0,
                                                        width: view.bounds.width,
                                                        height: view.bounds.height),
                                          collectionViewLayout: viewModel.layout)
        configureSeriesSections()
    }
    func configureSeriesSections() {
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
    func configureDataSource(_ viewModel: SeriesModels.InitialData.ViewModel) {
        guard let collectionView = collectionView else {
            print("\(String(describing: SeriesViewController.self)): Failed to get collection view.")
            return
        }
        let cellRegistration = UICollectionView.CellRegistration<VideoOnDemandCell, UUID>.init(cellNib: VideoOnDemandCell.cellNibName) { [weak self] cell, indexPath, id in
            let request = SeriesModels.SeriesData.Request(object: cell, indexPath: indexPath)
            self?.interactor?.fetchSeries(request)
        }
        let headerRegistration = UICollectionView.SupplementaryRegistration<TitleSupplementaryView>(elementKind: SupplementaryElementKind.sectionHeader) { [weak self] supplementaryView, elementKind, indexPath in
            let request = SeriesModels.SeriesData.Request(object: supplementaryView, indexPath: indexPath)
            self?.interactor?.fetchSeriesSectionHeader(request)
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
extension SeriesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let request = SeriesModels.SelectSeries.Request(indexPath: indexPath)
        interactor?.didSelectSeries(request)
    }
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if context.previouslyFocusedItem as? VideoOnDemandCell != nil,
           let nextFocusedItem = context.nextFocusedItem as? VideoOnDemandCell,
           let indexPath = collectionView.indexPath(for: nextFocusedItem) {
            let request = SeriesModels.FocusChangedInSeriesCollection.Request(nextIndexPath: indexPath)
            interactor?.focusChangedInSeriesCollection(request)
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

// MARK: - Conforming to SeriesDisplayLogic
extension SeriesViewController: SeriesDisplayLogic {
    func displaySeriesSecitons(_ viewModel: SeriesModels.InitialData.ViewModel) {
        configureHierarchy(viewModel)
        configureDataSource(viewModel)
    }

    func displaySeries(_ viewModel: SeriesModels.SeriesData.ViewModel) {
        guard let cell = viewModel.object as? VideoOnDemandCell, let series = viewModel.series else {
            return
        }
        cell.setVideoItem(series)
    }

    func displaySeriesSectionHeader(_ viewModel: SeriesModels.SeriesData.ViewModel) {
        guard let headerView = viewModel.object as? TitleSupplementaryView, let categoryTitle = viewModel.categoryTile else {
            return
        }
        headerView.setTitle(categoryTitle)
    }

    func setSeriesCollectionPosition(_ viewModel: SeriesModels.FocusChangedInSeriesCollection.ViewModel) {
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

    func notifyHomeSceneToShowSidebar(_ viewModel: SeriesModels.FocusChangedInSeriesCollection.ViewModel) {
        let request = HomeModels.SideBarAppearance.Request()
        homeSidebarAppearanceDelegate?.showHomeSidebar(request)
    }

    func notifyHomeSceneToHideSidebar(_ viewModel: SeriesModels.FocusChangedInSeriesCollection.ViewModel) {
        let request = HomeModels.SideBarAppearance.Request()
        homeSidebarAppearanceDelegate?.hideHomeSideBar(request)
    }

    func displaySelectedSeries(_ viewModel: SeriesModels.SelectSeries.ViewModel) {
        router?.routeToContentDetails()
    }
}
