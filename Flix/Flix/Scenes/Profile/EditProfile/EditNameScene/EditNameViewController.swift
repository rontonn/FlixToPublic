//
//  
//  EditNameViewController.swift
//  Flix
//
//  Created by Anton Romanov on 05.11.2021.
//
//

import UIKit

protocol EditNameDisplayLogic: AnyObject {
    func displayCurrentName(_ viewModel: EditNameModels.InitialData.ViewModel)
    func displayEditNameSuccess(_ viewModel: EditNameModels.Result.ViewModel)
    func displayEditNameError(_ viewModel: EditNameModels.Result.ViewModel)
}

final class EditNameViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private (set) weak var nameTextField: UITextField!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var saveButton: UIButton!
    
    // MARK: - Properties
    var interactor: EditNameBusinessLogic?
    var router: EditNameRouterable?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        let request = EditNameModels.InitialData.Request()
        interactor?.fetchCurrentName(request)
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        coordinator.addCoordinatedAnimations {
            let duration = UIView.inheritedAnimationDuration
            UIView.animate(withDuration: (0.85 * duration),
                           delay: 0.0,
                           options: UIView.AnimationOptions.overrideInheritedDuration,
                           animations: {
                if let nextFocusedItem = context.nextFocusedItem, nextFocusedItem.isEqual(self.saveButton) {
                    self.setSaveButtonFocusedState()
                }
                if let previouslyFocusedItem = context.previouslyFocusedItem, previouslyFocusedItem.isEqual(self.saveButton) {
                    self.setSaveButtonUnfocusedState()
                }
            })
        } completion: {}
    }

    // MARK: - IBActions
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        let request = EditNameModels.Result.Request(newName: nameTextField.text)
        interactor?.didPressSaveNameButton(request)
    }
}

// MARK: - Private methods
private extension EditNameViewController {
    func configure() {
        titleLabel.text = "edit_name_title".localized

        nameTextField.layer.masksToBounds = true
        nameTextField.layer.cornerRadius = 19
        nameTextField.backgroundColor = .white.withAlphaComponent(0.3)
        nameTextField.textColor = .black
        nameTextField.font = .jakarta(font: .display, ofSize: 28, weight: .medium)

        saveButton.setTitle("save_button_title".localized, for: .normal)
        saveButton.clipsToBounds = true
        saveButton.layer.cornerRadius = 30
        setSaveButtonUnfocusedState()
    }

    func setSaveButtonFocusedState() {
        saveButton.layer.borderColor = UIColor.clear.cgColor
        saveButton.layer.borderWidth = 0
        saveButton.layer.backgroundColor = UIColor.creamyPeach.cgColor
        saveButton.titleLabel?.font = UIFont.jakarta(font: .display, ofSize: 28, weight: .medium)
    }
    
    func setSaveButtonUnfocusedState() {
        saveButton.layer.borderColor = UIColor.white.withAlphaComponent(0.34).cgColor
        saveButton.layer.borderWidth = 1
        saveButton.layer.backgroundColor = UIColor.white.withAlphaComponent(0.12).cgColor
        saveButton.titleLabel?.font = UIFont.jakarta(font: .display, ofSize: 26, weight: .medium)
    }
}

// MARK: - Conforming to EditNameDisplayLogic
extension EditNameViewController: EditNameDisplayLogic {
    func displayCurrentName(_ viewModel: EditNameModels.InitialData.ViewModel) {
        nameTextField.text = viewModel.name
    }

    func displayEditNameSuccess(_ viewModel: EditNameModels.Result.ViewModel) {
        
    }

    func displayEditNameError(_ viewModel: EditNameModels.Result.ViewModel) {
        router?.routeToErrorSceene()
    }
}
