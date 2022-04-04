//
//  
//  EditProfileRouter.swift
//  Flix
//
//  Created by Anton Romanov on 03.11.2021.
//
//

import UIKit

typealias EditProfileRouterable = EditProfileRoutingLogic & EditProfileDataPassing

protocol EditProfileRoutingLogic {
    func routeToEditName()
    func routeToEditProfileImageScene()
    func routeToEditConsumptionTimeScene()
}

protocol EditProfileDataPassing {
    var dataStore: EditProfileDataStore? { get }
}

final class EditProfileRouter: EditProfileRouterable {
    // MARK: - Properties
    weak var viewController: EditProfileViewController?
    var dataStore: EditProfileDataStore?

    private weak var activeEditOptionViewViewController: UIViewController? {
        didSet {
            guard oldValue != activeEditOptionViewViewController else {
                return
            }
            removeInactiveChild(inactiveViewControler: oldValue)
            showActiveViewController()
        }
    }
    private var editNameViewController: EditNameViewController?
    private var editProfileImageViewController: EditProfileImageViewController?
    private var editConsumptionTimeViewController: EditConsumptionTimeViewController?

    // MARK: - Routing
    func routeToEditName() {
        if editNameViewController == nil {
            editNameViewController = EditNameBuilder().createEditNameScene()
        }
        if var editNameDataStore = editNameViewController?.router?.dataStore {
            passDataToEditNameScene(destination: &editNameDataStore)
        }
        updateActiveViewController(wtih: editNameViewController)
    }

    func routeToEditProfileImageScene() {
        if editProfileImageViewController == nil {
            editProfileImageViewController = EditProfileImageBuilder().createEditProfileImageScene()
        }
        if var editProfileImageDataStore = editProfileImageViewController?.router?.dataStore {
            passDataToEditProfileImageScene(destination: &editProfileImageDataStore)
        }
        updateActiveViewController(wtih: editProfileImageViewController)
    }

    func routeToEditConsumptionTimeScene() {
        if editConsumptionTimeViewController == nil {
            editConsumptionTimeViewController = EditConsumptionTimeBuilder().createEditConsumptionTimeScene()
        }
        if var editConsumptionTimeDataStore = editConsumptionTimeViewController?.router?.dataStore {
            passDataToEditConsumptionTimeScene(destination: &editConsumptionTimeDataStore)
        }
        updateActiveViewController(wtih: editConsumptionTimeViewController)
    }
}

// MARK: - Private methods
private extension EditProfileRouter {
    func removeInactiveChild(inactiveViewControler: UIViewController?) {
        if let inactiveViewControler = inactiveViewControler {
            inactiveViewControler.willMove(toParent: nil)
            inactiveViewControler.view.removeFromSuperview()
            inactiveViewControler.removeFromParent()
        }
    }
    func updateActiveViewController(wtih vc: UIViewController?) {
        activeEditOptionViewViewController = vc
    }
    func showActiveViewController() {
        if let activeSceneTabViewViewController = activeEditOptionViewViewController,
           let editOptionContainerView = viewController?.editOptionContainerView {
            viewController?.addChild(activeSceneTabViewViewController)
            activeSceneTabViewViewController.view.frame = editOptionContainerView.bounds
            editOptionContainerView.addSubview(activeSceneTabViewViewController.view)
            activeSceneTabViewViewController.didMove(toParent: viewController)
        }
    }

    // MARK: - Navigation

    // MARK: - Passing data
    func passDataToEditNameScene(destination: inout EditNameDataStore) {
        destination.editNameResultableDelegate = dataStore?.editNameResultableDelegate
        destination.currentName = dataStore?.profileToEdit?.fullName
    }

    func passDataToEditProfileImageScene(destination: inout EditProfileImageDataStore) {
        destination.editProfileImageResultable = dataStore?.editProfileImageResultable
        destination.profileImage = dataStore?.profileToEdit?.profileImage
    }

    func passDataToEditConsumptionTimeScene(destination: inout EditConsumptionTimeDataStore) {
        destination.availableConsumptionTime = dataStore?.profileToEdit?.subscriptionPlan
    }
}
