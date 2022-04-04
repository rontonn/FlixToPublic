//
//  ProfilesInteractorTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 16.11.2021.
//

import XCTest
@testable import Flix

final class ProfilesInteractorTests: XCTestCase {

    // MARK: - Properties
    private var sut: ProfilesInteractor!
    private var presenter: ProfilesPresentationLogicSpy!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let interactor = ProfilesInteractor()
        let presenter = ProfilesPresentationLogicSpy()

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
        let request = ProfilesModels.InitialData.Request()
        sut.fetchProfiles(request)

        XCTAssertTrue(presenter.isCalledPresentProfiles, "Not started present profiles.")
    }

    func testFetchProfile() {
        let profiles = [Profile(userData: nil),
                        Profile(userData: nil)]
        sut.profiles = profiles

        let firstSection = 0
        let numberOfItems = sut.profiles.count
        let request = ProfilesModels.ProfileData.Request(object: nil, indexPath: IndexPath(item: numberOfItems - 1, section: firstSection))
        sut.fetchProfile(request)

        XCTAssertTrue(presenter.isCalledPresentProfile, "Not started present profile.")
    }

    func testFetchProfileWithoutProfile() {
        let request = ProfilesModels.ProfileData.Request(object: nil, indexPath: IndexPath(item: 0, section: 0))
        sut.fetchProfile(request)

        XCTAssertFalse(presenter.isCalledPresentProfile, "Should not start present profile.")
    }

    func testDidSelectProfile() {
        let profiles = [Profile(userData: nil),
                        Profile(userData: nil)]
        sut.profiles = profiles
        let selectedProfileName = profiles[0].fullName
        let selectedProfileID = profiles[0].id

        let request = ProfilesModels.EditProfile.Request(indexPath: IndexPath(item: 0, section: 0))
        sut.didSelectProfile(request)

        XCTAssertEqual(sut.profileToEdit?.fullName, selectedProfileName)
        XCTAssertEqual(sut.profileToEdit?.id, selectedProfileID)
        XCTAssertTrue(presenter.isCalledPresentEditProfile, "Not started present edit selected profile.")
        XCTAssertFalse(presenter.isCalledPresentLoading, "Should not start present laoding.")
    }

    func testDidSelectLogout() {
        if let logout = Profile(.logout) {
            sut.profiles = [logout]
        }

        let request = ProfilesModels.EditProfile.Request(indexPath: IndexPath(item: 0, section: 0))
        sut.didSelectProfile(request)

        XCTAssertFalse(presenter.isCalledPresentEditProfile, "Should not start present edit selected profile.")
        XCTAssertTrue(presenter.isCalledPresentLoading, "Not started present laoding.")
    }

    func testDidSelectProfileFailed() {
        let numberOfImtems = sut.profiles.count
        let request = ProfilesModels.EditProfile.Request(indexPath: IndexPath(item: numberOfImtems, section: 1))
        sut.didSelectProfile(request)

        XCTAssertEqual(sut.profileToEdit?.fullName, nil)
        XCTAssertEqual(sut.profileToEdit?.id, nil)
        XCTAssertFalse(presenter.isCalledPresentEditProfile, "Should not start present selected profile.")
        XCTAssertFalse(presenter.isCalledPresentLoading, "Should not start present laoding.")
    }
}
