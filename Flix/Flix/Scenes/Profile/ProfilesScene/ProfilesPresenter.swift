//
//  
//  ProfilesPresenter.swift
//  Flix
//
//  Created by Anton Romanov on 02.11.2021.
//
//

import UIKit

protocol ProfilesPresentationLogic {
    func presentProfiles(_ response: ProfilesModels.InitialData.Response)
    func presentProfile(_ response: ProfilesModels.ProfileData.Response)
    func presentEditProfile(_ response: ProfilesModels.EditProfile.Response)
    func presentLoading(_ response: ProfilesModels.EditProfile.Response)
}

final class ProfilesPresenter {
    // MARK: - Properties
    weak var viewController: ProfilesDisplayLogic?

    private let profilesSectionUUID = UUID()
}

extension ProfilesPresenter: ProfilesPresentationLogic {
    func presentProfiles(_ response: ProfilesModels.InitialData.Response) {
        let profilesCollectionLayoutSource = ProfilesCollectionLayoutSource()
        let layout = profilesCollectionLayoutSource.createLayout()

        let snapshot = dataSourceSnapshotFor(response.profiles)
        let viewModel = ProfilesModels.InitialData.ViewModel(dataSourceSnapshot: snapshot, layout: layout)
        viewController?.displayProfiles(viewModel)
    }

    func presentProfile(_ response: ProfilesModels.ProfileData.Response) {
        let viewModel = ProfilesModels.ProfileData.ViewModel(object: response.object, profile: response.profile)
        viewController?.displayProfile(viewModel)
    }

    func presentEditProfile(_ response: ProfilesModels.EditProfile.Response) {
        let viewModel = ProfilesModels.EditProfile.ViewModel()
        viewController?.displayEditProfile(viewModel)
    }

    func presentLoading(_ response: ProfilesModels.EditProfile.Response) {
        let viewModel = ProfilesModels.EditProfile.ViewModel()
        viewController?.displayLoading(viewModel)
    }
}

// MARK: - Private methods
private extension ProfilesPresenter {
    func dataSourceSnapshotFor(_ profiles: [Profile]) -> NSDiffableDataSourceSnapshot<UUID, UUID> {
        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        snapshot.appendSections([profilesSectionUUID])
        let uuids = profiles.map{ $0.id }
        snapshot.appendItems(uuids)
        return snapshot
    }
}
