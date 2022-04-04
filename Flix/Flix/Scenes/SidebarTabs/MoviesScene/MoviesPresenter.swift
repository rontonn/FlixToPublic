//
//  
//  MoviesPresenter.swift
//  Flix
//
//  Created by Anton Romanov on 15.10.2021.
//
//

import UIKit

protocol MoviesPresentationLogic {
    func presentSections(_ response: MoviesModels.InitialData.Response)
    func presentMovie(_ response: MoviesModels.MovieData.Response)
    func presentMovieSectionHeader(_ response: MoviesModels.MovieData.Response)
    func focusChangedInMoviesCollection(_ response: MoviesModels.FocusChangedInMoviesCollection.Response)
    func presentSelectedMovie(_ response: MoviesModels.SelectMovie.Response)
}

final class MoviesPresenter {
    // MARK: - Properties
    weak var viewController: MoviesDisplayLogic?

    private let numberOfItemsInRow: CGFloat = 4
    private let leadingPaddingOfMoviesCollectionByDefault: CGFloat = 200
    private let leadingPaddingOfMoviesCollectionExpanded: CGFloat = 50
}

extension MoviesPresenter: MoviesPresentationLogic {
    func presentSections(_ response: MoviesModels.InitialData.Response) {
        let moviesCollectionLayoutSource = MoviesCollectionLayoutSource(numberOfItemsInRow: numberOfItemsInRow)
        let layout = moviesCollectionLayoutSource.createLayout()

        let snapshot = dataSourceSnapshotFor(response.movieSections)

        let viewModel = MoviesModels.InitialData.ViewModel(dataSourceSnapshot: snapshot,
                                                           layout: layout,
                                                           leadingPadding: leadingPaddingOfMoviesCollectionByDefault)
        viewController?.displayMovieSecitons(viewModel)
    }

    func presentMovie(_ response: MoviesModels.MovieData.Response) {
        let viewModel = MoviesModels.MovieData.ViewModel(object: response.object, categoryTile: response.categoryTile, movie: response.movie)
        viewController?.displayMovie(viewModel)
    }

    func presentMovieSectionHeader(_ response: MoviesModels.MovieData.Response) {
        let viewModel = MoviesModels.MovieData.ViewModel(object: response.object, categoryTile: response.categoryTile, movie: response.movie)
        viewController?.displayMovieSectionHeader(viewModel)
    }

    func focusChangedInMoviesCollection(_ response: MoviesModels.FocusChangedInMoviesCollection.Response) {
        guard numberOfItemsInRow != 0 else {
            return
        }
        
        let afterNextPosition = response.nextIndexPathItem + 1
        let itemPosition = CGFloat(afterNextPosition)

        notifyHomeSceneAboutSideBarPositionIfNeededFor(itemPosition)
        setMovieCollectionPositionIfNeededFor(itemPosition)
    }

    func presentSelectedMovie(_ response: MoviesModels.SelectMovie.Response) {
        let viewModel = MoviesModels.SelectMovie.ViewModel()
        viewController?.displaySelectedMovie(viewModel)
    }
}

// MARK: - Private methods {
private extension MoviesPresenter {
    func notifyHomeSceneAboutSideBarPositionIfNeededFor(_ itemPosition: CGFloat) {
        let viewModel = MoviesModels.FocusChangedInMoviesCollection.ViewModel(leadingPadding: nil)
        if itemPosition >= numberOfItemsInRow {
            viewController?.notifyHomeSceneToHideSidebar(viewModel)

        } else if itemPosition == 1 {
            viewController?.notifyHomeSceneToShowSidebar(viewModel)
        }
    }

    func setMovieCollectionPositionIfNeededFor(_ itemPosition: CGFloat) {
        var leadingPadding: CGFloat?

        if itemPosition >= numberOfItemsInRow {
            leadingPadding = leadingPaddingOfMoviesCollectionExpanded

        } else if itemPosition == 1 {
            leadingPadding = leadingPaddingOfMoviesCollectionByDefault
        }
        let viewModel = MoviesModels.FocusChangedInMoviesCollection.ViewModel(leadingPadding: leadingPadding)
        viewController?.setMoviesCollectionPosition(viewModel)
    }

    func dataSourceSnapshotFor(_ movieSections: [VideoOnDemandSection]) -> NSDiffableDataSourceSnapshot<UUID, UUID> {
        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        movieSections.forEach {
            snapshot.appendSections([$0.id])
            let uuids: [UUID] = $0.items.map{ $0.id }
            snapshot.appendItems(uuids, toSection: $0.id)
        }
        return snapshot
    }
}
