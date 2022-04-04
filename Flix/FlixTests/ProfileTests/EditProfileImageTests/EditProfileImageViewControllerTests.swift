//
//  EditProfileImageViewControllerTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 16.11.2021.
//

import XCTest
@testable import Flix

final class EditProfileImageViewControllerTests: XCTestCase {

    // MARK: - Properties
    private var sut: EditProfileImageViewController!
    private var interactor: EditProfileImageBusinessLogicSpy!
    private var window: UIWindow!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let mainWindow = UIWindow()

        let viewController = AppScene.editProfileImage.viewController(EditProfileImageViewController.self)
        let interactor = EditProfileImageBusinessLogicSpy()

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

        XCTAssertTrue(interactor.isCalledFetchEditProfileImageOptions, "Not started interactor request FetchEditProfileImageOptions.")
    }

    func testFetchEditProfileImageOption() {
        let layout = EditProfileImageCollectionLayoutSource().createLayout()

        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        snapshot.appendSections([UUID()])
        let uuids = randomUUIDs()
        snapshot.appendItems(uuids)

        let viewModel = EditProfileImageModels.InitialData.ViewModel(topPadding: 0,
                                                                     profileImage: nil,
                                                                     dataSourceSnapshot: snapshot,
                                                                     layout: layout)

        sut.displayEditProfileImageOptions(viewModel)

        let itemsCount = sut.collectionView?.numberOfItems(inSection: 0)
        XCTAssertEqual(itemsCount, uuids.count)

        XCTAssertTrue(interactor.isCalledFetchEditProfileImageOption, "Not started interactor request FetchEditProfileImageOption.")
    }

    func testFetchEditProfileImageOptionWithDefaultCollectionViewLayout() {
        let layout = UICollectionViewLayout()

        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        snapshot.appendSections([UUID()])
        snapshot.appendItems([UUID()])

        let viewModel = EditProfileImageModels.InitialData.ViewModel(topPadding: 0,
                                                                     profileImage: nil,
                                                                     dataSourceSnapshot: snapshot,
                                                                     layout: layout)

        sut.displayEditProfileImageOptions(viewModel)

        XCTAssertFalse(interactor.isCalledFetchEditProfileImageOption, "Should not start interactor request FetchEditProfileImageOption.")
    }

    func testFetchEditProfileImageOptionWithEmptyOptions() {
        let layout = UICollectionViewLayout()

        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        snapshot.appendSections([UUID()])

        let viewModel = EditProfileImageModels.InitialData.ViewModel(topPadding: 0,
                                                                     profileImage: nil,
                                                                     dataSourceSnapshot: snapshot,
                                                                     layout: layout)

        sut.displayEditProfileImageOptions(viewModel)

        XCTAssertFalse(interactor.isCalledFetchEditProfileImageOption, "Should not start interactor request FetchEditProfileImageOption.")
    }
}
