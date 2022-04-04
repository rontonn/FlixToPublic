//
//  
//  VideoOnDemandDetailsBuilder.swift
//  Flix
//
//  Created by Anton Romanov on 21.10.2021.
//
//

protocol VideoOnDemandDetailssBuildingLogic {
    func createVideoOnDemandDetailsScene() -> VideoOnDemandDetailsViewController?
}

final class VideoOnDemandDetailsBuilder: VideoOnDemandDetailssBuildingLogic {
    func createVideoOnDemandDetailsScene() -> VideoOnDemandDetailsViewController? {

        guard let vc = AppScene.videoOnDemandDetails.viewController(VideoOnDemandDetailsViewController.self) else {
            return nil
        }
        let interactor = VideoOnDemandDetailsInteractor()
        let presenter = VideoOnDemandDetailsPresenter()
        let router = VideoOnDemandDetailsRouter()

        interactor.presenter = presenter
        presenter.viewController = vc
        router.viewController = vc
        router.dataStore = interactor

        vc.interactor = interactor
        vc.router = router
        return vc
    }
}
