//
//  ProfilesViewControllerTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 16.11.2021.
//

import XCTest
@testable import Flix

final class ProfilesViewControllerTests: XCTestCase {

    // MARK: - Properties
    private var sut: ProfilesViewController!
    private var interactor: ProfilesBusinessLogicSpy!
    private var window: UIWindow!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let mainWindow = UIWindow()

        let viewController = AppScene.profiles.viewController(ProfilesViewController.self)
        let interactor = ProfilesBusinessLogicSpy()

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

        XCTAssertTrue(interactor.isCalledFetchProfiles, "Not started interactor request FetchProfiles.")
    }

    func testFetchProfile() {
        let layout = ProfilesCollectionLayoutSource().createLayout()

        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        snapshot.appendSections([UUID()])
        let itemUUIDs = randomUUIDs()
        snapshot.appendItems(itemUUIDs)

        let viewModel = ProfilesModels.InitialData.ViewModel(dataSourceSnapshot: snapshot, layout: layout)

        sut.displayProfiles(viewModel)
        XCTAssertTrue(interactor.isCalledFetchProfile, "Not started interactor request FetchProfile.")
    }

    func testFetchProfileWithDefaultCollectionViewlayout() {
        let layout = UICollectionViewLayout()

        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        snapshot.appendSections([UUID()])
        let itemUUIDs = randomUUIDs()
        snapshot.appendItems(itemUUIDs)

        let viewModel = ProfilesModels.InitialData.ViewModel(dataSourceSnapshot: snapshot, layout: layout)

        sut.displayProfiles(viewModel)
        XCTAssertFalse(interactor.isCalledFetchProfile, "Should not start interactor request FetchProfile.")
    }

    func testDidSelectProfile() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        sut.collectionView(collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))

        XCTAssertTrue(interactor.isCalledDidSelectProfile, "Not started interactor request DidSelectProfile.")
    }
}
