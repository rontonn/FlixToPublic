//
//  
//  MoviesInteractor.swift
//  Flix
//
//  Created by Anton Romanov on 15.10.2021.
//
//

import UIKit

protocol MoviesBusinessLogic {
    func fetchMovieCategories(_ request: MoviesModels.InitialData.Request)
    func fetchMovie(_ request: MoviesModels.MovieData.Request)
    func fetchMovieSectionHeader(_ request: MoviesModels.MovieData.Request)
    func focusChangedInMoviesCollection(_ request: MoviesModels.FocusChangedInMoviesCollection.Request)
    func didSelectMovie(_ request: MoviesModels.SelectMovie.Request)
}

protocol MoviesDataStore {
    var selectedMovie: VideoOnDemandItem? { get }
    var movieSections: [VideoOnDemandSection] { get }
}

final class MoviesInteractor: MoviesDataStore {
    // MARK: - Properties
    var presenter: MoviesPresentationLogic?
    var selectedMovie: VideoOnDemandItem?
    var movieSections: [VideoOnDemandSection] = []
}

extension MoviesInteractor: MoviesBusinessLogic {
    func fetchMovieCategories(_ request: MoviesModels.InitialData.Request) {
        var section1 = [VideoOnDemandItem]()
        var section2 = [VideoOnDemandItem]()
        var section3 = [VideoOnDemandItem]()
        var section4 = [VideoOnDemandItem]()
        
        for _ in 0...Int.random(in: 1...10) {
            let item = VideoOnDemandItem(poster: UIImage(named: "testPoster\(Int.random(in: 1...7))"),
                                         title: "item \(Int.random(in: 1...100))",
                                         ratingOwner: "Privi",
                                         ratingValue: Float.random(in: 0...5),
                                         tag: VideoOnDemandItem.Tag.claimed)
            section1.append(item)
        }
        for _ in 0...Int.random(in: 1...10) {
            let item = VideoOnDemandItem(poster: UIImage(named: "testPoster\(Int.random(in: 1...7))"),
                                         title: "item \(Int.random(in: 1...100))",
                                         ratingOwner: "Privi",
                                         ratingValue: Float.random(in: 0...5),
                                         tag: nil)
            section2.append(item)
        }
        for _ in 0...Int.random(in: 1...10) {
            let item = VideoOnDemandItem(poster: UIImage(named: "testPoster\(Int.random(in: 1...7))"),
                                         title: "item \(Int.random(in: 1...100))",
                                         ratingOwner: "Privi",
                                         ratingValue: Float.random(in: 0...5),
                                         tag: VideoOnDemandItem.Tag.staked)
            section3.append(item)
        }
        for _ in 0...Int.random(in: 1...10) {
            let item = VideoOnDemandItem(poster: UIImage(named: "testPoster\(Int.random(in: 1...7))"),
                                         title: "item \(Int.random(in: 1...100))",
                                         ratingOwner: "Privi",
                                         ratingValue: Float.random(in: 0...5),
                                         tag: VideoOnDemandItem.Tag.claimed)
            section4.append(item)
        }
        movieSections = [VideoOnDemandSection(categoryTitle: "Section Movies 1", items: section1, type: .movie),
                         VideoOnDemandSection(categoryTitle: "Section Movies 2", items: section2, type: .movie),
                         VideoOnDemandSection(categoryTitle: "Section Movies 3", items: section3, type: .movie),
                         VideoOnDemandSection(categoryTitle: "Section Movies 4", items: section4, type: .movie)]
        let response = MoviesModels.InitialData.Response(movieSections: movieSections)

        presenter?.presentSections(response)
    }

    func fetchMovie(_ request: MoviesModels.MovieData.Request) {
        guard let movieSection = movieSections[safe: request.indexPath.section],
              let movie = movieSection.items[safe: request.indexPath.item] else {
            return
        }
        let response = MoviesModels.MovieData.Response(object: request.object, categoryTile: nil, movie: movie)
        presenter?.presentMovie(response)
    }

    func fetchMovieSectionHeader(_ request: MoviesModels.MovieData.Request) {
        guard let movieSection = movieSections[safe: request.indexPath.section] else {
            return
        }
        let response = MoviesModels.MovieData.Response(object: request.object, categoryTile: movieSection.categoryTitle, movie: nil)
        presenter?.presentMovieSectionHeader(response)
    }

    func focusChangedInMoviesCollection(_ request: MoviesModels.FocusChangedInMoviesCollection.Request) {
        let response = MoviesModels.FocusChangedInMoviesCollection.Response(nextIndexPathItem: request.nextIndexPath.item)
        presenter?.focusChangedInMoviesCollection(response)
    }

    func didSelectMovie(_ request: MoviesModels.SelectMovie.Request) {
        guard let movieSection = movieSections[safe: request.indexPath.section],
              let selectedMovie = movieSection.items[safe: request.indexPath.item] else {
            return
        }
        self.selectedMovie = selectedMovie
        let response = MoviesModels.SelectMovie.Response()
        presenter?.presentSelectedMovie(response)
    }
}
