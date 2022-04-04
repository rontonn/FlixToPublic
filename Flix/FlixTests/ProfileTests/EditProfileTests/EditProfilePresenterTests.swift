//
//  EditProfilePresenterTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 16.11.2021.
//

import XCTest
@testable import Flix

final class EditProfilePresenterTests: XCTestCase {

    // MARK: - Properties
    private var sut: EditProfilePresenter!
    private var viewController: EditProfileDisplayLogicSpy!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let presenter = EditProfilePresenter()
        let viewController = EditProfileDisplayLogicSpy()

        presenter.viewController = viewController

        sut = presenter
        self.viewController = viewController
    }

    override func tearDown() {
        sut = nil
        viewController = nil

        super.tearDown()
    }

    // MARK: - Public Methods
    func testPresentEditProfileOptions() {
        let response = EditProfileModels.InitialData.Response(editProfileOptions: [])
        sut.presentEditProfileOptions(response)

        XCTAssertTrue(viewController.isCalledDisplayEditProfileOptions, "Not started viewController display edit profile options.")
    }

    func testPresentEditProfileOption() {
        let response = EditProfileModels.CollectionData.Response(object: nil, editProfileData: EditProfileData(option: .name(nil)))
        sut.presentEditProfileOption(response)

        XCTAssertTrue(viewController.isCalledDisplayEditProfileOption, "Not started viewController display edit profile option.")
    }

    func testPresentUpdateEditProfileOptions() {
        let response = EditProfileModels.UpdatedData.Response()
        sut.presentUpdatedEditProfilesOptions(response)

        XCTAssertTrue(viewController.isCalledDisplayUpdatedEditProfileOptions, "Not started viewController display updated edit profile options.")
    }

    func testPresentAfterFocusUpdateWhenOptionIsMissing() {
        let response = EditProfileModels.FocusUpdated.Response(option: nil)
        sut.presentEditProfileDataAfterFocusUpdate(response)

        XCTAssertFalse(viewController.isCalledDisplayEditName, "Should not start viewController DisplayEditName.")
        XCTAssertFalse(viewController.isCalledDisplayEditProfileImageScene, "Should not start viewController DisplayEditProfileImageScene.")
        XCTAssertFalse(viewController.isCalledDisplayEditConsumptionTimeScene, "Should not start viewController DisplayEditConsumptionTimeScene.")
    }

    func testPresentAfterFocusUpdateToEditName() {
        let response = EditProfileModels.FocusUpdated.Response(option: .name(nil))
        sut.presentEditProfileDataAfterFocusUpdate(response)

        XCTAssertTrue(viewController.isCalledDisplayEditName, "Not started viewController DisplayEditName.")
        XCTAssertFalse(viewController.isCalledDisplayEditProfileImageScene, "Should not start viewController DisplayEditProfileImageScene.")
        XCTAssertFalse(viewController.isCalledDisplayEditConsumptionTimeScene, "Should not start viewController DisplayEditConsumptionTimeScene.")
    }

    func testPresentAfterFocusUpdateToEditProfileImage() {
        let response = EditProfileModels.FocusUpdated.Response(option: .profileImage(nil))
        sut.presentEditProfileDataAfterFocusUpdate(response)

        XCTAssertFalse(viewController.isCalledDisplayEditName, "Should not start viewController DisplayEditName.")
        XCTAssertTrue(viewController.isCalledDisplayEditProfileImageScene, "Not started viewController DisplayEditProfileImageScene.")
        XCTAssertFalse(viewController.isCalledDisplayEditConsumptionTimeScene, "Should not start viewController DisplayEditConsumptionTimeScene.")
    }

    func testPresentAfterFocusUpdateToEditConsumptionTme() {
        let response = EditProfileModels.FocusUpdated.Response(option: .subscriptionPlan(nil))
        sut.presentEditProfileDataAfterFocusUpdate(response)

        XCTAssertFalse(viewController.isCalledDisplayEditName, "Should not start viewController DisplayEditName.")
        XCTAssertFalse(viewController.isCalledDisplayEditProfileImageScene, "Should not start viewController DisplayEditProfileImageScene.")
        XCTAssertTrue(viewController.isCalledDisplayEditConsumptionTimeScene, "Not started viewController DisplayEditConsumptionTimeScene.")
    }
}
