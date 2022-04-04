//
//  MoviesDisplayLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 15.11.2021.
//

import Foundation
@testable import Flix

final class MoviesDisplayLogicSpy {
    // MARK: - Properties
    private (set) var isCalledDisplayMovieSecitons = false
    private (set) var isCalledDisplayMovie = false
    private (set) var isCalledDisplayMovieSectionHeader = false
    private (set) var isCalledSetMoviesCollectionPosition = false
    private (set) var isCalledDisplaySelectedMovie = false
    private (set) var isCalledNotifyHomeSceneToShowSidebar = false
    private (set) var isCalledNotifyHomeSceneToHideSidebar = false
}

extension MoviesDisplayLogicSpy: MoviesDisplayLogic {
    func displayMovieSecitons(_ viewModel: MoviesModels.InitialData.ViewModel) {
        isCalledDisplayMovieSecitons = true
    }

    func displayMovie(_ viewModel: MoviesModels.MovieData.ViewModel) {
        isCalledDisplayMovie = true
    }

    func displayMovieSectionHeader(_ viewModel: MoviesModels.MovieData.ViewModel) {
        isCalledDisplayMovieSectionHeader = true
    }

    func setMoviesCollectionPosition(_ viewModel: MoviesModels.FocusChangedInMoviesCollection.ViewModel) {
        isCalledSetMoviesCollectionPosition = true
    }

    func notifyHomeSceneToShowSidebar(_ viewModel: MoviesModels.FocusChangedInMoviesCollection.ViewModel) {
        isCalledNotifyHomeSceneToShowSidebar = true
    }

    func notifyHomeSceneToHideSidebar(_ viewModel: MoviesModels.FocusChangedInMoviesCollection.ViewModel) {
        isCalledNotifyHomeSceneToHideSidebar = true
    }

    func displaySelectedMovie(_ viewModel: MoviesModels.SelectMovie.ViewModel) {
        isCalledDisplaySelectedMovie = true
    }
}
