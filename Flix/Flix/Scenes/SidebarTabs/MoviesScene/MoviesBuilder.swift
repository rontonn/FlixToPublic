//
//  
//  MoviesBuilder.swift
//  Flix
//
//  Created by Anton Romanov on 15.10.2021.
//
//

protocol MoviesBuildingLogic {
    func createMoviesScene(homeSidebarAppearanceDelegate: HomeSidebarAppearance?) -> MoviesViewController?
}

final class MoviesBuilder: MoviesBuildingLogic {
    func createMoviesScene(homeSidebarAppearanceDelegate: HomeSidebarAppearance?) -> MoviesViewController? {

        guard let vc = AppScene.movies.viewController(MoviesViewController.self) else {
            return nil
        }
        let interactor = MoviesInteractor()
        let presenter = MoviesPresenter()
        let router = MoviesRouter()

        interactor.presenter = presenter
        presenter.viewController = vc
        router.viewController = vc
        router.dataStore = interactor

        vc.interactor = interactor
        vc.router = router
        vc.homeSidebarAppearanceDelegate = homeSidebarAppearanceDelegate
        return vc
    }
}
