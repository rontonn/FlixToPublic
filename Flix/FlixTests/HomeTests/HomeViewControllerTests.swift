//
//  HomeViewControllerTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 15.11.2021.
//

import XCTest
@testable import Flix

final class HomeViewControllerTests: XCTestCase {

    // MARK: - Properties
    private var sut: HomeViewController!
    private var interactor: HomeBusinessLogicSpy!
    private var window: UIWindow!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let mainWindow = UIWindow()
        let viewController = AppScene.home.viewController(HomeViewController.self)
        let interactor = HomeBusinessLogicSpy()

        viewController?.interactor = interactor

        sut = viewController
        window = mainWindow
        self.interactor = interactor

        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }

    override func tearDown() {
        sut = nil
        interactor = nil
        window = nil

        super.tearDown()
    }

    // MARK: - Public Methods
    func testViewDidLoad() {
        sut.viewDidLoad()

        XCTAssertTrue(interactor.isCalledProvideSceneTabs, "Not started interactor request provideSceneTabs.")
    }

    func testFetchSceneTab() {
        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        snapshot.appendSections([UUID()])
        let itemUUIDs = randomUUIDs()
        snapshot.appendItems(itemUUIDs)

        let layout = HomeSceneTabsCollectionLayoutSource().createLayout()
        let viewModel = HomeModels.InitialData.ViewModel(dataSourceSnapshot: snapshot, layout: layout)
        sut.displaySceneTabs(viewModel)
        XCTAssertTrue(interactor.isCalledFetchSceneTab, "Not started interactor request FetchSceneTab.")
    }

    func testFetchSceneTabWithZeroNumberOfItemsInRow() {
        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        snapshot.appendSections([UUID()])

        let layout = HomeSceneTabsCollectionLayoutSource().createLayout()
        let viewModel = HomeModels.InitialData.ViewModel(dataSourceSnapshot: snapshot, layout: layout)
        sut.displaySceneTabs(viewModel)
        XCTAssertFalse(interactor.isCalledFetchSceneTab, "Should not start interactor request FetchSceneTab.")
    }

    func testFetchSceneTabWithDefaultCollectionViewLayout() {
        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        snapshot.appendSections([UUID()])
        let itemUUIDs = randomUUIDs()
        snapshot.appendItems(itemUUIDs)

        let layout = UICollectionViewLayout()
        let viewModel = HomeModels.InitialData.ViewModel(dataSourceSnapshot: snapshot, layout: layout)
        sut.displaySceneTabs(viewModel)
        XCTAssertFalse(interactor.isCalledFetchSceneTab, "Should not start interactor request FetchSceneTab.")
    }

    func testShowHomeSidebar() {
        let request = HomeModels.SideBarAppearance.Request()
        sut.showHomeSidebar(request)

        XCTAssertTrue(interactor.isCalledShowHomeSidebar, "Not started interactor request ShowHomeSidebar.")
    }

    func testHideHomeSidebar() {
        let request = HomeModels.SideBarAppearance.Request()
        sut.hideHomeSideBar(request)

        XCTAssertTrue(interactor.isCalledHideHomeSideBar, "Not started interactor request HideHomeSidebar.")
    }

    func testCollectionDidSelectItem() {
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        sut.collectionView(collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))

        XCTAssertTrue(interactor.isCalledDidSelectHomeTab, "Not started interactor request DidSelectHomeTab.")
    }

    @MainActor
    func testOnAuthorise() {
        sut.onAuthorise()
        XCTAssertTrue(interactor.isCalledOnAuthorise, "Not started interactor request OnAuthorise.")
    }

    @MainActor
    func testOnDisconnect() {
        sut.onDisconnect()
        XCTAssertTrue(interactor.isCalledOnDisconnect, "Not started interactor request OnDisconnect.")
    }
}
