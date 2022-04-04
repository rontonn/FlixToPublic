//
//  
//  MoviesViewController.swift
//  Flix
//
//  Created by Anton Romanov on 15.10.2021.
//
//

import UIKit

protocol MoviesDisplayLogic: AnyObject {
    func displayMovieSecitons(_ viewModel: MoviesModels.InitialData.ViewModel)
    func displayMovie(_ viewModel: MoviesModels.MovieData.ViewModel)
    func displayMovieSectionHeader(_ viewModel: MoviesModels.MovieData.ViewModel)
    func setMoviesCollectionPosition(_ viewModel: MoviesModels.FocusChangedInMoviesCollection.ViewModel)
    func notifyHomeSceneToShowSidebar(_ viewModel: MoviesModels.FocusChangedInMoviesCollection.ViewModel)
    func notifyHomeSceneToHideSidebar(_ viewModel: MoviesModels.FocusChangedInMoviesCollection.ViewModel)
    func displaySelectedMovie(_ viewModel: MoviesModels.SelectMovie.ViewModel)
}

final class MoviesViewController: UIViewController {
    // MARK: - Properties
    var interactor: MoviesBusinessLogic?
    var router: MoviesRouterable?
    weak var homeSidebarAppearanceDelegate: HomeSidebarAppearance?

    private var dataSource: UICollectionViewDiffableDataSource<UUID, UUID>?
    private var collectionView: UICollectionView?
    private var prefferedSceneTabIndexPath: IndexPath = IndexPath(item: 0, section: 0)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = MoviesModels.InitialData.Request()
        interactor?.fetchMovieCategories(request)
    }
}

// MARK: - Private methods
private extension MoviesViewController {
    func configureHierarchy(_ viewModel: MoviesModels.InitialData.ViewModel) {
        collectionView = UICollectionView(frame: CGRect(x: viewModel.leadingPadding,
                                                        y: 0,
                                                        width: view.bounds.width,
                                                        height: view.bounds.height),
                                          collectionViewLayout: viewModel.layout)
        configureMovieSections()
    }

    func configureMovieSections() {
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

    func configureDataSource(_ viewModel: MoviesModels.InitialData.ViewModel) {
        guard let collectionView = collectionView else {
            print("\(String(describing: MoviesViewController.self)): Failed to get collection view.")
            return
        }
        let cellRegistration = UICollectionView.CellRegistration<VideoOnDemandCell, UUID>.init(cellNib: VideoOnDemandCell.cellNibName) { [weak self] cell, indexPath, id in
            let request = MoviesModels.MovieData.Request(object: cell, indexPath: indexPath)
            self?.interactor?.fetchMovie(request)
        }
        let headerRegistration = UICollectionView.SupplementaryRegistration<TitleSupplementaryView>(elementKind: SupplementaryElementKind.sectionHeader) { [weak self] supplementaryView, elementKind, indexPath in
            let request = MoviesModels.MovieData.Request(object: supplementaryView, indexPath: indexPath)
            self?.interactor?.fetchMovieSectionHeader(request)
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
extension MoviesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let request = MoviesModels.SelectMovie.Request(indexPath: indexPath)
        interactor?.didSelectMovie(request)
    }

    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if context.previouslyFocusedItem as? VideoOnDemandCell != nil,
           let nextFocusedItem = context.nextFocusedItem as? VideoOnDemandCell,
           let indexPath = collectionView.indexPath(for: nextFocusedItem) {
            let request = MoviesModels.FocusChangedInMoviesCollection.Request(nextIndexPath: indexPath)
            interactor?.focusChangedInMoviesCollection(request)
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

// MARK: - Conforming to MoviesDisplayLogic
extension MoviesViewController: MoviesDisplayLogic {
    func displayMovieSecitons(_ viewModel: MoviesModels.InitialData.ViewModel) {
        configureHierarchy(viewModel)
        configureDataSource(viewModel)
    }

    func displayMovie(_ viewModel: MoviesModels.MovieData.ViewModel) {
        guard let cell = viewModel.object as? VideoOnDemandCell, let movie = viewModel.movie else {
            return
        }
        cell.setVideoItem(movie)
    }

    func displayMovieSectionHeader(_ viewModel: MoviesModels.MovieData.ViewModel) {
        guard let headerView = viewModel.object as? TitleSupplementaryView, let categoryTitle = viewModel.categoryTile else {
            return
        }
        headerView.setTitle(categoryTitle)
    }

    func setMoviesCollectionPosition(_ viewModel: MoviesModels.FocusChangedInMoviesCollection.ViewModel) {
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

    func notifyHomeSceneToShowSidebar(_ viewModel: MoviesModels.FocusChangedInMoviesCollection.ViewModel) {
        let request = HomeModels.SideBarAppearance.Request()
        homeSidebarAppearanceDelegate?.showHomeSidebar(request)
    }

    func notifyHomeSceneToHideSidebar(_ viewModel: MoviesModels.FocusChangedInMoviesCollection.ViewModel) {
        let request = HomeModels.SideBarAppearance.Request()
        homeSidebarAppearanceDelegate?.hideHomeSideBar(request)
    }

    func displaySelectedMovie(_ viewModel: MoviesModels.SelectMovie.ViewModel) {
        router?.routeToContentDetails()
    }
}
