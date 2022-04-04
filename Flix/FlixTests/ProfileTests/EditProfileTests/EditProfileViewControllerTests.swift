//
//  EditProfileViewControllerTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 16.11.2021.
//

import XCTest
@testable import Flix

final class EditProfileViewControllerTests: XCTestCase {

    // MARK: - Properties
    private var sut: EditProfileViewController!
    private var interactor: EditProfileBusinessLogicSpy!
    private var window: UIWindow!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let mainWindow = UIWindow()

        let viewController = AppScene.editProfile.viewController(EditProfileViewController.self)
        let interactor = EditProfileBusinessLogicSpy()

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

        XCTAssertTrue(interactor.isCalledFetchEditProfileOptions, "Not started interactor request FetchEditProfileOptions.")
    }

    func testFetchEditProfileOption() {
        let layout = EditProfileCollectionLayoutSource().createLayout()

        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        snapshot.appendSections([UUID()])
        let uuids = randomUUIDs()
        snapshot.appendItems(uuids)
        let viewModel = EditProfileModels.InitialData.ViewModel(leadingPadding: 0,
                                                                topPadding: 0,
                                                                dataSourceSnapshot: snapshot,
                                                                layout: layout)

        sut.displayEditProfileOptions(viewModel)

        let itemsCount = sut.collectionView?.numberOfItems(inSection: 0)
        XCTAssertEqual(itemsCount, uuids.count)

        XCTAssertTrue(interactor.isCalledFetchEditProfileOption, "Not started interactor request FetchEditProfileOption.")
    }

    func testFetchEditProfileOptionWithDefaultCollectionViewLayout() {
        let layout = UICollectionViewLayout()

        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        snapshot.appendSections([UUID()])
        snapshot.appendItems([UUID()])
        let viewModel = EditProfileModels.InitialData.ViewModel(leadingPadding: 0,
                                                                topPadding: 0,
                                                                dataSourceSnapshot: snapshot,
                                                                layout: layout)

        sut.displayEditProfileOptions(viewModel)

        XCTAssertFalse(interactor.isCalledFetchEditProfileOption, "Should not start interactor request FetchEditProfileOption.")
    }

    func testFetchEditProfileOptionWithEmptyOptions() {
        let layout = UICollectionViewLayout()

        let snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        let viewModel = EditProfileModels.InitialData.ViewModel(leadingPadding: 0,
                                                                topPadding: 0,
                                                                dataSourceSnapshot: snapshot,
                                                                layout: layout)

        sut.displayEditProfileOptions(viewModel)

        XCTAssertFalse(interactor.isCalledFetchEditProfileOption, "Should not start interactor request FetchEditProfileOption.")
    }

    func testFocusUpdate() {
        sut.focusUpdated(to: nil)

        XCTAssertTrue(interactor.isCalledDidUpdateFocus, "Not started interactor request DidUpdateFocus.")
    }
}
