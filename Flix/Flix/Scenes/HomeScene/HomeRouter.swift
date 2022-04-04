//
//  
//  HomeRouter.swift
//  FlixAR
//
//  Created by Anton Romanov on 12.10.2021.
//
//

import UIKit

typealias HomeRouterable = HomeRoutingLogic & HomeDataPassing

protocol HomeRoutingLogic {
    func routeTo(_ sceneTab: SceneTab?, fromFocusUpdate: Bool)
    func dismissAllPresented(_ completion: EmptyClosure?)
}

protocol HomeDataPassing {
    var dataStore: HomeDataStore? { get }
}

final class HomeRouter: HomeRouterable {
    // MARK: - Properties
    weak var viewController: HomeViewController?
    var dataStore: HomeDataStore?

    private weak var activeSceneTabViewViewController: UIViewController? {
        didSet {
            guard oldValue != activeSceneTabViewViewController else {
                return
            }
            removeInactiveChild(inactiveViewControler: oldValue)
            showActiveViewController()
        }
    }
    private var moviesViewController: MoviesViewController?
    private var seriesViewController: SeriesViewController?
    private var musicViewController: MusicViewController?
    private var tvViewController: TvViewController?

    private lazy var transitionHelper = ControllerTransitionHelper(.fadeTransitionWithLogo)

    // MARK: - Routing
    func routeTo(_ sceneTab: SceneTab?, fromFocusUpdate: Bool) {
        switch sceneTab?.option {
        case .profile:
            if fromFocusUpdate {
                return
            }
            showUserScene()
        case .movies:
            showMoviesScene()
        case .series:
            showSeriesScene()
        case .music:
            showMusicScene()
        case .tv:
            showTvScene()
        case .none:
            break
        }
    }

    func dismissAllPresented(_ completion: EmptyClosure?) {
        if let presentedViewController = viewController?.presentedViewController {
            presentedViewController.dismiss(animated: true, completion: {
                self.dismissAllPresented(completion)
            })
        } else {
            completion?()
        }
    }
}

// MARK: - Private methods
private extension HomeRouter {
    func showUserScene() {
        if AccountsWorker.shared.isAuthorised {
            showProfilesScene()
        } else {
            showSignInScene()
        }
    }

    func showSignInScene() {
        guard let signInVC = SignInBuilder().createSignInScene() else {
          return
        }
        navigateToSignInScene(signInVC)
    }

    func showProfilesScene() {
        guard let profileVC = ProfilesBuilder().createProfilesScene() else {
          return
        }
        navigateToProfileScene(profileVC)
    }

    func showMoviesScene() {
        if moviesViewController == nil {
            moviesViewController = MoviesBuilder().createMoviesScene(homeSidebarAppearanceDelegate: viewController)
        }
        if var moviesDataStore = moviesViewController?.router?.dataStore {
            passDataToMoviesScene(destination: &moviesDataStore)
        }
        updateActiveViewController(wtih: moviesViewController)
    }

    func showSeriesScene() {
        if seriesViewController == nil {
            seriesViewController = SeriesBuilder().createSeriesScene(homeSidebarAppearanceDelegate: viewController)
        }
        if var seriesDataStore = seriesViewController?.router?.dataStore {
            passDataToSeriesScene(destination: &seriesDataStore)
        }
        updateActiveViewController(wtih: seriesViewController)
    }

    func showMusicScene() {
        if musicViewController == nil {
            musicViewController = MusicBuilder().createMusicScene(homeSidebarAppearanceDelegate: viewController)
        }
        if var musicDataStore = musicViewController?.router?.dataStore {
            passDataToMusicScene(destination: &musicDataStore)
        }
        updateActiveViewController(wtih: musicViewController)
    }

    func showTvScene() {
        if tvViewController == nil {
            tvViewController = TvBuilder().createTvScene(homeSidebarAppearanceDelegate: viewController)
        }
        if var tvDataStore = tvViewController?.router?.dataStore {
            passDataToTvScene(destination: &tvDataStore)
        }
        updateActiveViewController(wtih: tvViewController)
    }

    func removeInactiveChild(inactiveViewControler: UIViewController?) {
        if let inactiveViewControler = inactiveViewControler {
            inactiveViewControler.willMove(toParent: nil)
            inactiveViewControler.view.removeFromSuperview()
            inactiveViewControler.removeFromParent()
        }
    }

    func updateActiveViewController(wtih vc: UIViewController?) {
        activeSceneTabViewViewController = vc
    }

    func showActiveViewController() {
        if let activeSceneTabViewViewController = activeSceneTabViewViewController,
           let sceneContainer = viewController?.sceneContainerView {
            viewController?.addChild(activeSceneTabViewViewController)
            activeSceneTabViewViewController.view.frame = sceneContainer.bounds
            sceneContainer.addSubview(activeSceneTabViewViewController.view)
            activeSceneTabViewViewController.didMove(toParent: viewController)
        }
    }

    // MARK: - Navigation
    func navigateToSignInScene(_ vc: SignInViewController) {
        vc.transitioningDelegate = transitionHelper
        vc.modalPresentationStyle = .custom
        viewController?.present(vc, animated: true)
    }

    func navigateToProfileScene(_ vc: ProfilesViewController) {
        vc.transitioningDelegate = transitionHelper
        vc.modalPresentationStyle = .custom
        viewController?.present(vc, animated: true)
    }

    // MARK: - Passing data
    func passDataToMoviesScene(destination: inout MoviesDataStore) {
    }

    func passDataToSeriesScene(destination: inout SeriesDataStore) {
    }

    func passDataToMusicScene(destination: inout MusicDataStore) {
    }

    func passDataToTvScene(destination: inout TvDataStore) {
    }
}
