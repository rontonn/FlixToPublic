//
//  SignInViewControllerTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 17.11.2021.
//

import XCTest
@testable import Flix

final class SignInViewControllerTests: XCTestCase {

    // MARK: - Properties
    private var sut: SignInViewController!
    private var interactor: SignInBusinessLogicSpy!
    private var window: UIWindow!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let mainWindow = UIWindow()

        let viewController = AppScene.signIn.viewController(SignInViewController.self)
        let interactor = SignInBusinessLogicSpy()

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

        XCTAssertTrue(interactor.isCalledProvideSignInOptions, "Not started interactor request ProvideSignInOptions.")
    }

    func testFetchSignInOptionData() {
        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        snapshot.appendSections([UUID()])
        let itemUUIDs = randomUUIDs()
        snapshot.appendItems(itemUUIDs)

        let layout = SignInCollectionLayoutSource().createLayout()
        let viewModel = SignInModels.InitialData.ViewModel(pageTitle: "", dataSourceSnapshot: snapshot, layout: layout)
        sut.displaySignInOptions(viewModel)
        XCTAssertTrue(interactor.isCalledProvideSignInOption, "Not started interactor request FetchSignInOptionData.")
    }

    func testFetchSceneTabWithZeroNumberOfItemsInRow() {
        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        snapshot.appendSections([UUID()])

        let layout = SignInCollectionLayoutSource().createLayout()
        let viewModel = SignInModels.InitialData.ViewModel(pageTitle: "", dataSourceSnapshot: snapshot, layout: layout)
        sut.displaySignInOptions(viewModel)
        XCTAssertFalse(interactor.isCalledProvideSignInOption, "Should not start interactor request FetchSignInOptionData.")
    }

    func testFetchSceneTabWithDefaultCollectionViewLayout() {
        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        snapshot.appendSections([UUID()])
        let itemUUIDs = randomUUIDs()
        snapshot.appendItems(itemUUIDs)

        let layout = UICollectionViewLayout()
        let viewModel = SignInModels.InitialData.ViewModel(pageTitle: "", dataSourceSnapshot: snapshot, layout: layout)
        sut.displaySignInOptions(viewModel)
        XCTAssertFalse(interactor.isCalledProvideSignInOption, "Should not start interactor request FetchSignInOptionData.")
    }

    func testDidSelectSignInOption() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        sut.collectionView(collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))

        XCTAssertTrue(interactor.isCalledDidSelectSignInOption, "Not started interactor request DidSelectSignInOption.")
    }
}
