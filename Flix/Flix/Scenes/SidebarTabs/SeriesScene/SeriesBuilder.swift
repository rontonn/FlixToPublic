//
//  
//  SeriesBuilder.swift
//  Flix
//
//  Created by Anton Romanov on 15.10.2021.
//
//

protocol SeriesBuildingLogic {
    func createSeriesScene(homeSidebarAppearanceDelegate: HomeSidebarAppearance?) -> SeriesViewController?
}

final class SeriesBuilder: SeriesBuildingLogic {
    func createSeriesScene(homeSidebarAppearanceDelegate: HomeSidebarAppearance?) -> SeriesViewController? {

        guard let vc = AppScene.series.viewController(SeriesViewController.self) else {
            return nil
        }
        let interactor = SeriesInteractor()
        let presenter = SeriesPresenter()
        let router = SeriesRouter()

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
