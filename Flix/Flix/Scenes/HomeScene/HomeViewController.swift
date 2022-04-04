//
//  
//  HomeViewController.swift
//  FlixAR
//
//  Created by Anton Romanov on 12.10.2021.
//
//

import UIKit

protocol HomeSidebarAppearance: AnyObject {
    func showHomeSidebar(_ request: HomeModels.SideBarAppearance.Request)
    func hideHomeSideBar(_ request: HomeModels.SideBarAppearance.Request)
}

protocol HomeDisplayLogic: AnyObject {
    func displaySceneTabs(_ viewModel: HomeModels.InitialData.ViewModel)
    func displaySceneTab(_ viewModel: HomeModels.SceneTabData.ViewModel)
    func focusUpdateCompleted(_ viewModel: HomeModels.FocusUpdateCompleted.ViewModel)
    func showHomeSidebar(_ viewModel: HomeModels.SideBarAppearance.ViewModel)
    func hideHomeSideBar(_ viewModel: HomeModels.SideBarAppearance.ViewModel)
    func displaySelectedHomeTab(_ viewModel: HomeModels.SelectHomeTab.ViewModel)
    func displayUpdatedTabs(_ viewModel: HomeModels.UpdatedData.ViewModel)
    func displayOnAuthorise(_ viewModel: HomeModels.UserSession.ViewModel)
    func displayOnDisconnect(_ viewModel: HomeModels.UserSession.ViewModel)
}

final class HomeViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var sceneTabsContainerView: UIView!
    @IBOutlet private (set) weak var sceneContainerView: UIView!

    // MARK: - Contraints
    @IBOutlet private weak var widthOfSceneTabsContainerView: NSLayoutConstraint!

    // MARK: - Properties
    var interactor: HomeBusinessLogic?
    var router: HomeRouterable?

    private var dataSource: UICollectionViewDiffableDataSource<UUID, UUID>?
    private (set) var collectionView: UICollectionView?
    private var prefferedSceneTabIndexPath: IndexPath = IndexPath(item: 1, section: 0)
    private let homeSideBarTopFocusGuide = UIFocusGuide()
    private let homeSideBarRightFocusGuide = UIFocusGuide()
    private let homeSideBarBottomFocusGuide = UIFocusGuide()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        AccountsWorker.shared.update(delegate: self)

        let request = HomeModels.InitialData.Request()
        interactor?.provideSceneTabs(request)
        addHomeSidebarFocusGuides()
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        coordinator.addCoordinatedAnimations {
        } completion: {
            if (context.nextFocusedItem as? SceneTabCell) != nil {
                self.homeSideBarRightFocusGuide.preferredFocusEnvironments = []
                self.didUpdateFocusToSceneTab(true)
            } else {
                if let collectionView = self.collectionView {
                    self.homeSideBarRightFocusGuide.preferredFocusEnvironments = [collectionView]
                }
                self.didUpdateFocusToSceneTab(false)
            }
        }
    }
}

// MARK: - Private methods
private extension HomeViewController {
    func addHomeSidebarFocusGuides() {
        sceneTabsContainerView.addLayoutGuide(homeSideBarRightFocusGuide)
        NSLayoutConstraint.activate([
            homeSideBarRightFocusGuide.topAnchor.constraint(equalTo: sceneTabsContainerView.topAnchor),
            homeSideBarRightFocusGuide.rightAnchor.constraint(equalTo: sceneTabsContainerView.rightAnchor),
            homeSideBarRightFocusGuide.widthAnchor.constraint(equalToConstant: 10),
            homeSideBarRightFocusGuide.bottomAnchor.constraint(equalTo: sceneTabsContainerView.bottomAnchor)
        ])

        if let collectionView = self.collectionView {
            self.homeSideBarTopFocusGuide.preferredFocusEnvironments = [collectionView]
        }
        sceneTabsContainerView.addLayoutGuide(homeSideBarTopFocusGuide)
        NSLayoutConstraint.activate([
            homeSideBarTopFocusGuide.leftAnchor.constraint(equalTo: sceneTabsContainerView.leftAnchor),
            homeSideBarTopFocusGuide.rightAnchor.constraint(equalTo: sceneTabsContainerView.rightAnchor),
            homeSideBarTopFocusGuide.heightAnchor.constraint(equalToConstant: 10),
            homeSideBarTopFocusGuide.bottomAnchor.constraint(equalTo: sceneTabsContainerView.topAnchor)
        ])

        if let collectionView = self.collectionView {
            self.homeSideBarBottomFocusGuide.preferredFocusEnvironments = [collectionView]
        }
        sceneTabsContainerView.addLayoutGuide(homeSideBarBottomFocusGuide)
        NSLayoutConstraint.activate([
            homeSideBarBottomFocusGuide.leftAnchor.constraint(equalTo: sceneTabsContainerView.leftAnchor),
            homeSideBarBottomFocusGuide.rightAnchor.constraint(equalTo: sceneTabsContainerView.rightAnchor),
            homeSideBarBottomFocusGuide.heightAnchor.constraint(equalToConstant: 10),
            homeSideBarBottomFocusGuide.topAnchor.constraint(equalTo: sceneTabsContainerView.bottomAnchor)
        ])
    }

    func didUpdateFocusToSceneTab(_ state: Bool) {
        let request = HomeModels.FocusUpdateCompleted.Request(currentWidthOfSceneTabsContainer: widthOfSceneTabsContainerView.constant,
                                                              toSceneTab: state)
        interactor?.focusUpdateCompleted(request)
    }

    func configureHierarchy(_ layout: UICollectionViewLayout) {
        collectionView = UICollectionView(frame: CGRect(x: 0,
                                                        y: 0,
                                                        width: sceneTabsContainerView.bounds.width - 10,
                                                        height: sceneTabsContainerView.bounds.height),
                                          collectionViewLayout: layout)
        configureSceneTabs(collectionView)
    }

    // -> SceneTabs
    func configureSceneTabs(_ collectionView: UICollectionView?) {
        guard let collectionView = collectionView  else {
            return
        }
        collectionView.remembersLastFocusedIndexPath = true
        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .greyB32
        collectionView.layer.cornerRadius = 44

        addShadowTo(collectionView)
        sceneTabsContainerView.addSubview(collectionView)
    }

    func addShadowTo(_ collectionView: UICollectionView) {
        collectionView.layer.shadowPath = UIBezierPath(rect: collectionView.bounds).cgPath
        collectionView.layer.shadowOpacity = 1
        collectionView.layer.shadowColor = UIColor.black.withAlphaComponent(0.56).cgColor
        collectionView.layer.shadowOffset = CGSize(width: 4, height: 4)
        collectionView.layer.shadowRadius = 21
        collectionView.layer.shouldRasterize = true
        collectionView.layer.rasterizationScale = UIScreen.main.scale
    }

    func configuresceneTabsDataSource(_ viewModel: HomeModels.InitialData.ViewModel) {
        guard let collectionView = collectionView else {
            print("\(String(describing: HomeViewController.self)): Failed to get collection view.")
            return
        }
        let cellRegistration = UICollectionView.CellRegistration<SceneTabCell, UUID> { [weak self] cell, indexPath, id in
            let request = HomeModels.SceneTabData.Request(object: cell, indexPath: indexPath)
            self?.interactor?.fetchSceneTab(request)
        }
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView,
                                                        cellProvider: { collectionView, indexPath, itemID in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemID)
        })
        dataSource?.apply(viewModel.dataSourceSnapshot, animatingDifferences: false)
    }
    // <- SceneTabs

    func setWidthOfSceneTabsContainerView(_ newWidth: CGFloat) {
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseInOut], animations: {
            self.widthOfSceneTabsContainerView.constant = newWidth
            self.view.layoutIfNeeded()
        })
    }

    func setSceneTabsContainerViewTransformTo(_ newTransform: CGAffineTransform) {
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseInOut], animations: {
            self.sceneTabsContainerView.transform = newTransform
        })
    }

    func authStatusChanged(_ completion: EmptyClosure? = nil) {
        router?.dismissAllPresented(completion)
        let request = HomeModels.UpdatedData.Request()
        interactor?.fetchUpdatedTabs(request)
    }
}

// MARK: - Conforming to HomeDisplayLogic
extension HomeViewController: HomeDisplayLogic {
    func displaySceneTabs(_ viewModel: HomeModels.InitialData.ViewModel) {
        configureHierarchy(viewModel.layout)
        configuresceneTabsDataSource(viewModel)
    }

    func displaySceneTab(_ viewModel: HomeModels.SceneTabData.ViewModel) {
        guard let cell = viewModel.object as? SceneTabCell else {
            return
        }
        cell.sceneTab = viewModel.sceneTab
        cell.delegate = self
    }

    func focusUpdateCompleted(_ viewModel: HomeModels.FocusUpdateCompleted.ViewModel) {
        setWidthOfSceneTabsContainerView(viewModel.widthOfSceneTabsContainer)
    }

    func showHomeSidebar(_ viewModel: HomeModels.SideBarAppearance.ViewModel) {
        setSceneTabsContainerViewTransformTo(.identity)
    }

    func hideHomeSideBar(_ viewModel: HomeModels.SideBarAppearance.ViewModel) {
        setSceneTabsContainerViewTransformTo(CGAffineTransform(translationX: -150, y: 0))
    }

    func displaySelectedHomeTab(_ viewModel: HomeModels.SelectHomeTab.ViewModel) {
        router?.routeTo(viewModel.sceneTab, fromFocusUpdate: false)
    }

    func displayUpdatedTabs(_ viewModel: HomeModels.UpdatedData.ViewModel) {
        if var currentSnapshot = dataSource?.snapshot() {
            let oldUUIDS = currentSnapshot.itemIdentifiers(inSection: viewModel.section)
            currentSnapshot.reconfigureItems(oldUUIDS)
            dataSource?.apply(currentSnapshot, animatingDifferences: true)
        }
    }

    func displayOnAuthorise(_ viewModel: HomeModels.UserSession.ViewModel) {
        authStatusChanged()
    }

    func displayOnDisconnect(_ viewModel: HomeModels.UserSession.ViewModel) {
        authStatusChanged { [weak self] in
            let request = HomeModels.SelectHomeTab.Request(indexPath: IndexPath(item: 0, section: 0))
            self?.interactor?.didSelectHomeTab(request)
        }
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let request = HomeModels.SelectHomeTab.Request(indexPath: indexPath)
        interactor?.didSelectHomeTab(request)
    }

    func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {
        return prefferedSceneTabIndexPath
    }

    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        prefferedSceneTabIndexPath = indexPath
        return true
    }
}

// MARK: - SceneTabCellDelegate
extension HomeViewController: SceneTabCellDelegate {
    func focusUpdated(to sceneTab: SceneTab?) {
        router?.routeTo(sceneTab, fromFocusUpdate: true)
    }
}

// MARK: - HomeSidebarAppearance
extension HomeViewController: HomeSidebarAppearance {
    func showHomeSidebar(_ request: HomeModels.SideBarAppearance.Request) {
        let request = HomeModels.SideBarAppearance.Request()
        interactor?.showHomeSidebar(request)
    }

    func hideHomeSideBar(_ request: HomeModels.SideBarAppearance.Request) {
        let request = HomeModels.SideBarAppearance.Request()
        interactor?.hideHomeSideBar(request)
    }
}

// MARK: - AccountsWorkerDelegate
extension HomeViewController: AccountsWorkerDelegate {
    func onAuthorise() {
        let request = HomeModels.UserSession.Request()
        interactor?.onAuthorise(request)
    }

    func onConnect() {
    }

    func onDisconnect() {
        let request = HomeModels.UserSession.Request()
        interactor?.onDisconnect(request)
    }

    func onFailure(_ error: PriviError) {
    }
}
