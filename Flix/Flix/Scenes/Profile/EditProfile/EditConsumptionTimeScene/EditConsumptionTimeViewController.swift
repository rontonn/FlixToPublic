//
//  
//  EditConsumptionTimeViewController.swift
//  Flix
//
//  Created by Anton Romanov on 09.11.2021.
//
//

import UIKit

protocol EditConsumptionTimeDisplayLogic: AnyObject {
    func displayAvailableConsumptionTime(_ viewModel: EditConsumptionTimeModels.InitialData.ViewModel)
}

final class EditConsumptionTimeViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private (set) weak var availableConsumptionTimeLabel: UILabel!
    @IBOutlet private weak var getMoreConsumptionTimeButton: UIButton!
    
    // MARK: - Properties
    var interactor: EditConsumptionTimeBusinessLogic?
    var router: EditConsumptionTimeRouterable?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        let request = EditConsumptionTimeModels.InitialData.Request()
        interactor?.fetchAvailableConsumptionTime(request)
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        coordinator.addCoordinatedAnimations {
            let duration = UIView.inheritedAnimationDuration
            UIView.animate(withDuration: (0.85 * duration),
                           delay: 0.0,
                           options: UIView.AnimationOptions.overrideInheritedDuration,
                           animations: {
                if let nextFocusedItem = context.nextFocusedItem, nextFocusedItem.isEqual(self.getMoreConsumptionTimeButton) {
                    self.setConsumptionTimeButtonFocusedState()
                }
                if let previouslyFocusedItem = context.previouslyFocusedItem, previouslyFocusedItem.isEqual(self.getMoreConsumptionTimeButton) {
                    self.setConsumptionTimeButtonUnfocusedState()
                }
            })
        } completion: {}
    }

    // MARK: - IBActions
    @IBAction func didPressGetMoreConsumptionTimeButton(_ sender: UIButton) {
        router?.routeToPurchaseConsumptionTimeSceene()
    }
}

// MARK: - Private methods
private extension EditConsumptionTimeViewController {
    func configure() {
        titleLabel.text = "available_consumption_time_title".localized

        getMoreConsumptionTimeButton.setTitle("get_more_watching_time_title".localized, for: .normal)
        getMoreConsumptionTimeButton.clipsToBounds = true
        getMoreConsumptionTimeButton.layer.cornerRadius = 30
        setConsumptionTimeButtonUnfocusedState()
    }

    func setConsumptionTimeButtonFocusedState() {
        getMoreConsumptionTimeButton.layer.borderColor = UIColor.clear.cgColor
        getMoreConsumptionTimeButton.layer.borderWidth = 0
        getMoreConsumptionTimeButton.layer.backgroundColor = UIColor.creamyPeach.cgColor
        getMoreConsumptionTimeButton.titleLabel?.font = UIFont.jakarta(font: .display, ofSize: 28, weight: .medium)
    }
    
    func setConsumptionTimeButtonUnfocusedState() {
        getMoreConsumptionTimeButton.layer.borderColor = UIColor.white.withAlphaComponent(0.34).cgColor
        getMoreConsumptionTimeButton.layer.borderWidth = 1
        getMoreConsumptionTimeButton.layer.backgroundColor = UIColor.white.withAlphaComponent(0.12).cgColor
        getMoreConsumptionTimeButton.titleLabel?.font = UIFont.jakarta(font: .display, ofSize: 26, weight: .medium)
    }
}

// MARK: - Conforming to EditConsumptionTimeDisplayLogic
extension EditConsumptionTimeViewController: EditConsumptionTimeDisplayLogic {
    func displayAvailableConsumptionTime(_ viewModel: EditConsumptionTimeModels.InitialData.ViewModel) {
        availableConsumptionTimeLabel.text = viewModel.availableConsumptionTime
    }
}
