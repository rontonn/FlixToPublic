//
//  ProfilesPresenterTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 16.11.2021.
//

import XCTest
@testable import Flix

final class ProfilesPresenterTests: XCTestCase {

    // MARK: - Properties
    private var sut: ProfilesPresenter!
    private var viewController: ProfilesDisplayLogicSpy!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let presenter = ProfilesPresenter()
        let viewController = ProfilesDisplayLogicSpy()

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
    func testPresentProfiles() {
        let response = ProfilesModels.InitialData.Response(profiles: [])
        sut.presentProfiles(response)

        XCTAssertTrue(viewController.isCalledDisplayProfiles, "Not started viewController display profile sections.")
    }

    func testPresentProfile() {
        let profile = Profile(userData: nil)
        let response = ProfilesModels.ProfileData.Response(object: nil, profile: profile)
        sut.presentProfile(response)

        XCTAssertTrue(viewController.isCalledDisplayProfile, "Not started viewController display profile.")
    }

    func testPresentLoading() {
        let response = ProfilesModels.EditProfile.Response()
        sut.presentLoading(response)

        XCTAssertTrue(viewController.isCalledDisplayLoading, "Not started viewController display loading.")
    }

    func testPresentSelectedProfileToEdit() {
        let response = ProfilesModels.EditProfile.Response()
        sut.presentEditProfile(response)

        XCTAssertTrue(viewController.isCalledDisplayEditProfile, "Not started viewController display edit selected profile.")
    }
}
