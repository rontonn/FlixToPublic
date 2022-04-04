//
//  EditProfileInteractorTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 16.11.2021.
//

import XCTest
@testable import Flix

final class EditProfileInteractorTests: XCTestCase {

    // MARK: - Properties
    private var sut: EditProfileInteractor!
    private var presenter: EditProfilePresentationLogicSpy!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let interactor = EditProfileInteractor()
        let presenter = EditProfilePresentationLogicSpy()

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
    func testFetchProfiles() {
        let request = EditProfileModels.InitialData.Request()
        sut.fetchEditProfileOptions(request)

        XCTAssertTrue(presenter.isCalledPresentEditProfileOptions, "Not started present edit profile options.")
    }

    func testFetchProfileForCollection() {
        let request = EditProfileModels.CollectionData.Request(object: nil, indexPath: IndexPath(item: 0, section: 0))
        sut.fetchEditProfileOption(request)

        XCTAssertTrue(presenter.isCalledPresentEditProfileOption, "Not started present edit profile option for collection.")
    }

    func testFetchProfileForCollectionFailed() {
        let numberOfImtems = sut.editOptions.count
        let request = EditProfileModels.CollectionData.Request(object: nil, indexPath: IndexPath(item: numberOfImtems, section: 0))
        sut.fetchEditProfileOption(request)

        XCTAssertFalse(presenter.isCalledPresentEditProfileOption, "Should not start present edit profile option for collection.")
    }

    func testUpdateProfileOptions() {
        let request = EditNameModels.Result.Request(newName: "")
        sut.didEditName(request)
    
        XCTAssertTrue(presenter.isCalledPresentUpdatedEditProfilesOptions, "Not started present updated edit profile options.")
    }

    func testFocusUpdate() {
        let request = EditProfileModels.FocusUpdated.Request(editProfileData: nil)
        sut.didUpdateFocus(request)

        XCTAssertTrue(presenter.isCalledPresentEditProfileDataAfterFocusUpdate, "Not started PresentEditProfileDataAfterFocusUpdate.")
    }
}
