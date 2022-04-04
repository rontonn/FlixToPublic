//
//  
//  EditProfileImageRouter.swift
//  Flix
//
//  Created by Anton Romanov on 08.11.2021.
//
//

import UIKit

typealias EditProfileImageRouterable = EditProfileImageRoutingLogic & EditProfileImageDataPassing

protocol EditProfileImageRoutingLogic {
}

protocol EditProfileImageDataPassing {
    var dataStore: EditProfileImageDataStore? { get }
}

final class EditProfileImageRouter: EditProfileImageRouterable {
    // MARK: - Properties
    weak var viewController: EditProfileImageViewController?
    var dataStore: EditProfileImageDataStore?

    // MARK: - Routing
}

private extension EditProfileImageRouter {
    // MARK: - Navigation

    // MARK: - Passing data
}
