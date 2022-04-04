//
//  
//  EditProfileImagePresenter.swift
//  Flix
//
//  Created by Anton Romanov on 08.11.2021.
//
//

import UIKit

protocol EditProfileImagePresentationLogic {
    func presentEditProfileImageOptions(_ response: EditProfileImageModels.InitialData.Response)
    func presentEditProfileImageOption(_ response: EditProfileImageModels.CollectionData.Response)
}

final class EditProfileImagePresenter {
    // MARK: - Properties
    weak var viewController: EditProfileImageDisplayLogic?

    private let editProfileImageOptionsSectionUUID = UUID()
}

extension EditProfileImagePresenter: EditProfileImagePresentationLogic {
    func presentEditProfileImageOptions(_ response: EditProfileImageModels.InitialData.Response) {
        let editProfileImageCollectionLayoutSource = EditProfileImageCollectionLayoutSource()
        let layout = editProfileImageCollectionLayoutSource.createLayout()

        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        snapshot.appendSections([editProfileImageOptionsSectionUUID])

        let uuids = response.editProfileImageOptions.map{ $0.id }
        snapshot.appendItems(uuids)
        let viewModel = EditProfileImageModels.InitialData.ViewModel(topPadding: 50,
                                                                     profileImage: response.profileImage,
                                                                     dataSourceSnapshot: snapshot,
                                                                     layout: layout)
        viewController?.displayEditProfileImageOptions(viewModel)
    }

    func presentEditProfileImageOption(_ response: EditProfileImageModels.CollectionData.Response) {
        let viewModel = EditProfileImageModels.CollectionData.ViewModel(object: response.object,
                                                                        editProfileImageOption: response.editProfileImageOption)
        viewController?.displayEditProfileImageOption(viewModel)
    }
    
}
