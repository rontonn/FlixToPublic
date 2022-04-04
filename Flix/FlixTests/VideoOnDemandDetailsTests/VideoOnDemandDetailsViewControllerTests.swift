//
//  VideoOnDemandDetailsViewControllerTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 17.11.2021.
//

import XCTest
@testable import Flix

final class VideoOnDemandDetailsViewControllerTests: XCTestCase {

    // MARK: - Properties
    private var sut: VideoOnDemandDetailsViewController!
    private var interactor: VideoOnDemandDetailsBusinessLogicSpy!
    private var window: UIWindow!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let mainWindow = UIWindow()

        let viewController = AppScene.videoOnDemandDetails.viewController(VideoOnDemandDetailsViewController.self)
        let interactor = VideoOnDemandDetailsBusinessLogicSpy()

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

        XCTAssertTrue(interactor.isCalledFetchVideoOnDemandDetails, "Not started interactor request FetchVideoOnDemandDetails.")
    }

    func testFetchVideoOnDemandDetailsAction() {
        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        snapshot.appendSections([UUID()])
        let itemUUIDs = randomUUIDs()
        snapshot.appendItems(itemUUIDs)

        let layout = VideoOnDemandDetailsCollectionLayoutSource().createLayout()
        let viewModel = VideoOnDemandDetailsModels.InitialData.ViewModel(dataSourceSnapshot: snapshot, layout: layout, videoOnDemandItem: nil)
        sut.displayVideoOnDemandDetails(viewModel)
        XCTAssertTrue(interactor.isCalledFetchVideoOnDemandDetailsAction, "Not started interactor request FetchVideoOnDemandDetailsAction.")
    }

    func testFetchVideoOnDemandDetailsActionWithZeroNumberOfItemsInRow() {
        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        snapshot.appendSections([UUID()])

        let layout = VideoOnDemandDetailsCollectionLayoutSource().createLayout()
        let viewModel = VideoOnDemandDetailsModels.InitialData.ViewModel(dataSourceSnapshot: snapshot, layout: layout, videoOnDemandItem: nil)
        sut.displayVideoOnDemandDetails(viewModel)
        XCTAssertFalse(interactor.isCalledFetchVideoOnDemandDetailsAction, "Should not start interactor request FetchVideoOnDemandDetailsAction.")
    }

    func testFetchVideoOnDemandDetailsActionWithDefaultCollectionViewLayout() {
        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        snapshot.appendSections([UUID()])
        let itemUUIDs = randomUUIDs()
        snapshot.appendItems(itemUUIDs)

        let layout = UICollectionViewLayout()
        let viewModel = VideoOnDemandDetailsModels.InitialData.ViewModel(dataSourceSnapshot: snapshot, layout: layout, videoOnDemandItem: nil)
        sut.displayVideoOnDemandDetails(viewModel)
        XCTAssertFalse(interactor.isCalledFetchVideoOnDemandDetailsAction, "Should not start interactor request FetchVideoOnDemandDetailsAction.")
    }

    func testDidSelectVideoOnDemandDetailsAction() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        sut.collectionView(collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))

        XCTAssertTrue(interactor.isCalledDidSelectVideoOnDemandDetailsAction, "Not started interactor request DidSelectVideoOnDemandDetailsAction.")
    }
}
