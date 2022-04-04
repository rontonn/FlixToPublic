//
//  
//  EditProfileImageInteractor.swift
//  Flix
//
//  Created by Anton Romanov on 08.11.2021.
//
//

import UIKit

protocol EditProfileImageResultable: AnyObject {
    func didEditProfileImage(_ request: EditProfileImageModels.Result.Request)
}

protocol EditProfileImageBusinessLogic {
    func fetchEditProfileImageOptions(_ request: EditProfileImageModels.InitialData.Request)
    func fetchEditProfileImageOption(_ request: EditProfileImageModels.CollectionData.Request)
}

protocol EditProfileImageDataStore {
    var profileImage: URL? { get set }
    var editProfileImageResultable: EditProfileImageResultable? { get set }
    var editProfileImageOptions: [EditProfileImageData] { get }
}

final class EditProfileImageInteractor: EditProfileImageDataStore {
    // MARK: - Properties
    var presenter: EditProfileImagePresentationLogic?
    var profileImage: URL?
    weak var editProfileImageResultable: EditProfileImageResultable?

    var editProfileImageOptions: [EditProfileImageData] {
        return [EditProfileImageData(option: .change),
                EditProfileImageData(option: .remove)]
    }
}

extension EditProfileImageInteractor: EditProfileImageBusinessLogic {
    func fetchEditProfileImageOptions(_ request: EditProfileImageModels.InitialData.Request) {
        let response = EditProfileImageModels.InitialData.Response(profileImage: profileImage,
                                                                   editProfileImageOptions: editProfileImageOptions)
        presenter?.presentEditProfileImageOptions(response)
    }
    
    func fetchEditProfileImageOption(_ request: EditProfileImageModels.CollectionData.Request) {
        guard let option = editProfileImageOptions.first(where: { $0.priority == request.indexPath.item }) else {
            return
        }
        let response = EditProfileImageModels.CollectionData.Response(object: request.object,
                                                                      editProfileImageOption: option)
        presenter?.presentEditProfileImageOption(response)
    }
}
