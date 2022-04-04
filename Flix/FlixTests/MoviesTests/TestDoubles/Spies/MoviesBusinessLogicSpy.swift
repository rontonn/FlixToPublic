//
//  MoviesBusinessLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 15.11.2021.
//

import Foundation
@testable import Flix

final class MoviesBusinessLogicSpy {
    // MARK: - Properties
    private (set) var isCalledFetchMovieCategories = false
    private (set) var isCalledFetchMovie = false
    private (set) var isCalledFetchMovieSectionHeader = false
    private (set) var isCalledFocusChangedInMoviesCollection = false
    private (set) var isCalledDidSelectMovie = false
}

extension MoviesBusinessLogicSpy: MoviesBusinessLogic {
    func fetchMovieCategories(_ request: MoviesModels.InitialData.Request) {
        isCalledFetchMovieCategories = true
    }

    func fetchMovie(_ request: MoviesModels.MovieData.Request) {
        isCalledFetchMovie = true
    }

    func fetchMovieSectionHeader(_ request: MoviesModels.MovieData.Request) {
        isCalledFetchMovieSectionHeader = true
    }

    func focusChangedInMoviesCollection(_ request: MoviesModels.FocusChangedInMoviesCollection.Request) {
        isCalledFocusChangedInMoviesCollection = true
    }

    func didSelectMovie(_ request: MoviesModels.SelectMovie.Request) {
        isCalledDidSelectMovie = true
    }
}
