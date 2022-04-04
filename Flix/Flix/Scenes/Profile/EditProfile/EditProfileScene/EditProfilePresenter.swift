//
//  
//  EditProfilePresenter.swift
//  Flix
//
//  Created by Anton Romanov on 03.11.2021.
//
//

import UIKit

protocol EditProfilePresentationLogic {
    func presentEditProfileOptions(_ response: EditProfileModels.InitialData.Response)
    func presentEditProfileOption(_ response: EditProfileModels.CollectionData.Response)
    func presentUpdatedEditProfilesOptions(_ response: EditProfileModels.UpdatedData.Response)
    func presentEditProfileDataAfterFocusUpdate(_ response: EditProfileModels.FocusUpdated.Response)
}

final class EditProfilePresenter {
    // MARK: - Properties
    weak var viewController: EditProfileDisplayLogic?

    private let editProfileOptionsSectionUUID = UUID()
}

extension EditProfilePresenter: EditProfilePresentationLogic {
    func presentEditProfileOptions(_ response: EditProfileModels.InitialData.Response) {
        let editProfileCollectionLayoutSource = EditProfileCollectionLayoutSource()
        let layout = editProfileCollectionLayoutSource.createLayout()

        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        snapshot.appendSections([editProfileOptionsSectionUUID])

        let uuids = response.editProfileOptions.map{ $0.id }
        snapshot.appendItems(uuids)
        let viewModel = EditProfileModels.InitialData.ViewModel(leadingPadding: 58,
                                                                topPadding: 92,
                                                                dataSourceSnapshot: snapshot,
                                                                layout: layout)
        viewController?.displayEditProfileOptions(viewModel)
    }

    func presentEditProfileOption(_ response: EditProfileModels.CollectionData.Response) {
        let viewModel = EditProfileModels.CollectionData.ViewModel(object: response.object, editProfileData: response.editProfileData)
        viewController?.displayEditProfileOption(viewModel)
    }

    func presentUpdatedEditProfilesOptions(_ response: EditProfileModels.UpdatedData.Response) {
        let viewModel = EditProfileModels.UpdatedData.ViewModel(section: editProfileOptionsSectionUUID)
        viewController?.displayUpdatedEditProfileOptions(viewModel)
    }

    func presentEditProfileDataAfterFocusUpdate(_ response: EditProfileModels.FocusUpdated.Response) {
        let viewModel = EditProfileModels.FocusUpdated.ViewModel()
        switch response.option {
        case .name:
            viewController?.displayEditName(viewModel)
        case .profileImage:
            viewController?.displayEditProfileImageScene(viewModel)
        case .subscriptionPlan:
            viewController?.displayEditConsumptionTimeScene(viewModel)
        case .none:
            break
        }
    }
}
