//
//  
//  ProfilesInteractor.swift
//  Flix
//
//  Created by Anton Romanov on 02.11.2021.
//
//

import UIKit

protocol ProfilesBusinessLogic {
    func fetchProfiles(_ request: ProfilesModels.InitialData.Request)
    func fetchProfile(_ request: ProfilesModels.ProfileData.Request)
    func didSelectProfile(_ request: ProfilesModels.EditProfile.Request)
}

protocol ProfilesDataStore {
    var profileToEdit: Profile? { get }
}

final class ProfilesInteractor: ProfilesDataStore {
    // MARK: - Properties
    var presenter: ProfilesPresentationLogic?
    var profiles: [Profile] = []
    var profileToEdit: Profile?
}

extension ProfilesInteractor: ProfilesBusinessLogic {
    func fetchProfiles(_ request: ProfilesModels.InitialData.Request) {
        setupProfiles()
        let response = ProfilesModels.InitialData.Response(profiles: profiles)
        presenter?.presentProfiles(response)
    }

    func fetchProfile(_ request: ProfilesModels.ProfileData.Request) {
        guard let profile = profiles[safe: request.indexPath.item] else {
            return
        }
        let response = ProfilesModels.ProfileData.Response(object: request.object, profile: profile)
        presenter?.presentProfile(response)
    }

    func didSelectProfile(_ request: ProfilesModels.EditProfile.Request) {
        guard let profileToEdit = profiles[safe: request.indexPath.item] else {
                  return
              }
        let response = ProfilesModels.EditProfile.Response()
        switch profileToEdit.action {
        case .edit:
            self.profileToEdit = profileToEdit
            presenter?.presentEditProfile(response)
        case .logout:
            AccountsWorker.shared.disconnect()
            presenter?.presentLoading(response)
        }
    }
}

// MARK: - Private methods
private extension ProfilesInteractor {
    func setupProfiles() {
        profiles = AccountsWorker.shared.profiles
        addLogoutProfileIfNeeded()
    }

    func addLogoutProfileIfNeeded() {
        if let logoutProfile = Profile(.logout) {
            profiles.append(logoutProfile)
        }
    }
}
