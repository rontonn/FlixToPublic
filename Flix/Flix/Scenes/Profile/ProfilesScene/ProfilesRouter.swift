//
//  
//  ProfilesRouter.swift
//  Flix
//
//  Created by Anton Romanov on 02.11.2021.
//
//

import UIKit

typealias ProfilesRouterable = ProfilesRoutingLogic & ProfilesDataPassing

protocol ProfilesRoutingLogic {
    func routeToEditProfile()
}

protocol ProfilesDataPassing {
    var dataStore: ProfilesDataStore? { get }
}

final class ProfilesRouter: ProfilesRouterable {
    // MARK: - Properties
    weak var viewController: ProfilesViewController?
    var dataStore: ProfilesDataStore?

    private lazy var transitionHelper = ControllerTransitionHelper(.fadeTransitionWithLogo)

    // MARK: - Routing
    func routeToEditProfile() {
        guard let editProfileVC = EditProfileBuilder().createEditProfileScene(),
              var editProfileDataStore = editProfileVC.router?.dataStore else {
            return
        }
        passDataToEditProfile(destination: &editProfileDataStore)
        navigateToEditProfile(destination: editProfileVC)
    }
}

// MARK: - Private methods
private extension ProfilesRouter {
    // MARK: - Navigation
    func navigateToEditProfile(destination: EditProfileViewController) {
        destination.transitioningDelegate = transitionHelper
        destination.modalPresentationStyle = .custom
        viewController?.present(destination, animated: true)
    }

    // MARK: - Passing data
    func passDataToEditProfile(destination: inout EditProfileDataStore) {
        destination.profileToEdit = dataStore?.profileToEdit
    }
}
