//
//  
//  EditProfileInteractor.swift
//  Flix
//
//  Created by Anton Romanov on 03.11.2021.
//
//

import Foundation

protocol EditNameResultable: AnyObject {
    func didEditName(_ request: EditNameModels.Result.Request)
}

protocol EditProfileBusinessLogic {
    func fetchEditProfileOptions(_ request: EditProfileModels.InitialData.Request)
    func fetchEditProfileOption(_ request: EditProfileModels.CollectionData.Request)
    func didUpdateFocus(_ request: EditProfileModels.FocusUpdated.Request)
}

protocol EditProfileDataStore {
    var editOptions: [EditProfileData] { get }
    var profileToEdit: Profile? { get set }
    var editNameResultableDelegate: EditNameResultable? { get }
    var editProfileImageResultable: EditProfileImageResultable? { get }
}

final class EditProfileInteractor: EditProfileDataStore {
    // MARK: - Properties
    var presenter: EditProfilePresentationLogic?

    var editOptions: [EditProfileData] {
        return [EditProfileData(option: .name(profileToEdit?.fullName)),
                EditProfileData(option: .profileImage(profileToEdit?.profileImage)),
                EditProfileData(option: .subscriptionPlan(profileToEdit?.subscriptionPlan))]
    }
    var profileToEdit: Profile?
    weak var editNameResultableDelegate: EditNameResultable?
    weak var editProfileImageResultable: EditProfileImageResultable?
}

extension EditProfileInteractor: EditProfileBusinessLogic {
    func fetchEditProfileOptions(_ request: EditProfileModels.InitialData.Request) {
        let response = EditProfileModels.InitialData.Response(editProfileOptions: editOptions)
        presenter?.presentEditProfileOptions(response)
    }

    func fetchEditProfileOption(_ request: EditProfileModels.CollectionData.Request) {
        guard let option = editOptions.first(where: { $0.priority == request.indexPath.item }) else {
            return
        }
        let response = EditProfileModels.CollectionData.Response(object: request.object,
                                                                 editProfileData: option)
        presenter?.presentEditProfileOption(response)
    }

    func didUpdateFocus(_ request: EditProfileModels.FocusUpdated.Request) {
        let response = EditProfileModels.FocusUpdated.Response(option: request.editProfileData?.option)
        presenter?.presentEditProfileDataAfterFocusUpdate(response)
    }
}

extension EditProfileInteractor: EditNameResultable {
    func didEditName(_ request: EditNameModels.Result.Request) {
        if let userData = profileToEdit?.userData {
            self.profileToEdit = Profile(userData: userData)
        }
        let response = EditProfileModels.UpdatedData.Response()
        presenter?.presentUpdatedEditProfilesOptions(response)
    }
}

extension EditProfileInteractor: EditProfileImageResultable {
    func didEditProfileImage(_ request: EditProfileImageModels.Result.Request) {
        guard let userData = profileToEdit?.userData else {
            return
        }
        self.profileToEdit = Profile(userData: userData)
    }
}
