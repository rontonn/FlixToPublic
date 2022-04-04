//
//  MoviesPresentationLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 15.11.2021.
//

import Foundation
@testable import Flix

final class MoviesPresentationLogicSpy {
    // MARK: - Properties
    private (set) var isCalledPresentSections = false
    private (set) var isCalledPresentMovie = false
    private (set) var isCalledPresentMovieSectionHeader = false
    private (set) var isCalledFocusChangedInMoviesCollection = false
    private (set) var isCalledPresentSelectedMovie = false
}

extension MoviesPresentationLogicSpy: MoviesPresentationLogic {
    func presentSections(_ response: MoviesModels.InitialData.Response) {
        isCalledPresentSections = true
    }

    func presentMovie(_ response: MoviesModels.MovieData.Response) {
        isCalledPresentMovie = true
    }

    func presentMovieSectionHeader(_ response: MoviesModels.MovieData.Response) {
        isCalledPresentMovieSectionHeader = true
    }

    func focusChangedInMoviesCollection(_ response: MoviesModels.FocusChangedInMoviesCollection.Response) {
        isCalledFocusChangedInMoviesCollection = true
    }

    func presentSelectedMovie(_ response: MoviesModels.SelectMovie.Response) {
        isCalledPresentSelectedMovie = true
    }
}
