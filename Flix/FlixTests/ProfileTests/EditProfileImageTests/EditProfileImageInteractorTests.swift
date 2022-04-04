//
//  EditProfileImageInteractorTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 16.11.2021.
//

import XCTest
@testable import Flix

final class EditProfileImageInteractorTests: XCTestCase {

    // MARK: - Properties
    private var sut: EditProfileImageInteractor!
    private var presenter: EditProfileImagePresentationLogicSpy!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let interactor = EditProfileImageInteractor()
        let presenter = EditProfileImagePresentationLogicSpy()

        interactor.presenter = presenter

        sut = interactor
        self.presenter = presenter
    }

    override func tearDown() {
        sut = nil
        presenter = nil

        super.tearDown()
    }

    // MARK: - Public Methods
    func testFetchEditProfileImageOptions() {
        let request = EditProfileImageModels.InitialData.Request()
        sut.fetchEditProfileImageOptions(request)

        XCTAssertTrue(presenter.isCalledPresentEditProfileImageOptions, "Not started present edit profile image options.")
    }

    func testFetchEditProfileImageOption() {
        let request = EditProfileImageModels.CollectionData.Request(object: nil, indexPath: IndexPath(item: 0, section: 0))
        sut.fetchEditProfileImageOption(request)

        XCTAssertTrue(presenter.isCalledPresentEditProfileImageOption, "Not started present edit profile image option.")
    }

    func testFetchEditProfileImageOptionFailed() {
        let numberOfImtems = sut.editProfileImageOptions.count
        let request = EditProfileImageModels.CollectionData.Request(object: nil, indexPath: IndexPath(item: numberOfImtems, section: 0))
        sut.fetchEditProfileImageOption(request)

        XCTAssertFalse(presenter.isCalledPresentEditProfileImageOption, "Should not start present edit profile image option.")
    }
}
