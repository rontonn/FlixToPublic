//
//  EditProfileImagePresenterTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 16.11.2021.
//

import XCTest
@testable import Flix

final class EditProfileImagePresenterTests: XCTestCase {

    // MARK: - Properties
    private var sut: EditProfileImagePresenter!
    private var viewController: EditProfileImageDisplayLogicSpy!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        let presenter = EditProfileImagePresenter()
        let viewController = EditProfileImageDisplayLogicSpy()

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
    func testPresentEditProfileImageOptions() {
        let response = EditProfileImageModels.InitialData.Response(profileImage: nil, editProfileImageOptions: [])
        sut.presentEditProfileImageOptions(response)

        XCTAssertTrue(viewController.isCalledDisplayEditProfileImageOptions, "Not started viewController display edit profile image options.")
    }

    func testPresentEditProfileImageOption() {
        let response = EditProfileImageModels.CollectionData.Response(object: nil, editProfileImageOption: EditProfileImageData(option: .change))
        sut.presentEditProfileImageOption(response)

        XCTAssertTrue(viewController.isCalledDisplayEditProfileImageOption, "Not started viewController display edit profile image option.")
    }
}
