//
//  
//  ConfirmConsumptionTimePurchaseViewController.swift
//  Flix
//
//  Created by Anton Romanov on 10.11.2021.
//
//

import UIKit

protocol ConfirmConsumptionTimePurchaseDisplayLogic: AnyObject {
    func displayPurchaseOption(_ viewModel: ConfirmConsumptionTimePurchaseModels.InitialData.ViewModel)
    func didCompletePurchase(_ viewModel: ConfirmConsumptionTimePurchaseModels.MakePurchase.ViewModel)
}

final class ConfirmConsumptionTimePurchaseViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!

    @IBOutlet private weak var purchaseOptionContainerView: UIView!
    @IBOutlet private weak var addLabel: UILabel!
    @IBOutlet private weak var hoursLabel: UILabel!
    @IBOutlet private weak var forPriceLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    
    @IBOutlet private weak var rewardLabel: UILabel!
    @IBOutlet private weak var approveButton: UIButton!
    @IBOutlet private weak var bottomDetailsLabel: UILabel!

    // MARK: - Properties
    var interactor: ConfirmConsumptionTimePurchaseBusinessLogic?
    var router: ConfirmConsumptionTimePurchaseRouterable?
    private var loadingSpinnerView: LoadingSpinnerView?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()

        let request = ConfirmConsumptionTimePurchaseModels.InitialData.Request()
        interactor?.fetchPurchaseOption(request)
    }

    @IBAction func didPressApproveButton(_ sender: UIButton) {
        showLoader()

        let request = ConfirmConsumptionTimePurchaseModels.MakePurchase.Request()
        interactor?.didPressApproveConsumptionTimePurchase(request)
    }
}

// MARK: - Private methods
private extension ConfirmConsumptionTimePurchaseViewController {
    func configure() {
        view.backgroundColor = .black
        titleLabel.text = "confirm_purchase_title".localized
        titleLabel.textColor = .white
        titleLabel.font = .jakarta(font: .display, ofSize: 50, weight: .bold)
        subtitleLabel.text = "confirm_aprove_purchase_title".localized
        subtitleLabel.textColor = .white.withAlphaComponent(0.5)
        subtitleLabel.font = .jakarta(font: .display, ofSize: 28, weight: .medium)
        bottomDetailsLabel.text = "purchase_consumption_time_reward_note".localized
        bottomDetailsLabel.textColor = .white.withAlphaComponent(0.5)
        bottomDetailsLabel.font = .jakarta(font: .display, ofSize: 27, weight: .regular)
        
        purchaseOptionContainerView.layer.borderWidth = 4
        purchaseOptionContainerView.layer.borderColor = UIColor.peachE57.cgColor
        purchaseOptionContainerView.layer.backgroundColor = UIColor.brown737.cgColor
        purchaseOptionContainerView.layer.cornerRadius = 64
        purchaseOptionContainerView.clipsToBounds = true

        addLabel.font = .jakarta(font: .display, ofSize: 39, weight: .bold)
        addLabel.textColor = .white.withAlphaComponent(0.6)
        addLabel.text = "add_title".localized

        hoursLabel.font = .jakarta(font: .display, ofSize: 76, weight: .bold)
        hoursLabel.textColor = .white

        forPriceLabel.font = .jakarta(font: .display, ofSize: 22, weight: .bold)
        forPriceLabel.textColor = .white.withAlphaComponent(0.6)
        forPriceLabel.text = "for_title".localized

        priceLabel.font = .jakarta(font: .display, ofSize: 30, weight: .bold)
        priceLabel.textColor = .white.withAlphaComponent(0.6)
        
        rewardLabel.font = .jakarta(font: .display, ofSize: 26, weight: .bold)
        rewardLabel.textColor = .white.withAlphaComponent(0.6)
        
        
        approveButton.layer.cornerRadius = 45
        
        // Attributed title for button
        let attributedTitleForButton = NSMutableAttributedString(string: "")
        let approveButtonImage = #imageLiteral(resourceName: "smallWalletIcon")
        let imageAttachement = NSTextAttachment()
        imageAttachement.image = approveButtonImage
        let firstAttrString = NSAttributedString(attachment: imageAttachement)

        let secondAttr: [NSAttributedString.Key: Any] = [.font: UIFont.jakarta(font: .display, ofSize: 27, weight: .medium),
                                                         .foregroundColor: UIColor.white]
        let secondString = NSMutableAttributedString(string: "    " + "approve_purchase_through_wallet_title".localized, attributes: secondAttr)
        
        attributedTitleForButton.append(firstAttrString)
        attributedTitleForButton.append(secondString)
        approveButton.setAttributedTitle(attributedTitleForButton, for: .normal)
        //
        setApproveButtonFocusedState()
    }

    func setApproveButtonFocusedState() {
        approveButton.layer.borderColor = UIColor.clear.cgColor
        approveButton.layer.borderWidth = 0
        approveButton.layer.backgroundColor = UIColor.creamyPeach.cgColor
        approveButton.titleLabel?.font = UIFont.jakarta(font: .display, ofSize: 28, weight: .medium)
    }

    func showLoader() {
        let titles = LoadingSpinnerView.Titles(title: "processing_transsaction_title".localized,
                                               subtitle: "processing_transaction_subtitle".localized)
        loadingSpinnerView = LoadingSpinnerView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height),
                                                titles: titles)
        if let loadingSpinnerView = loadingSpinnerView {
            view.addSubview(loadingSpinnerView)
        }
        loadingSpinnerView?.startAnimating()
    }

    func hideLoader() {
        loadingSpinnerView?.stopAnimating()
        loadingSpinnerView?.removeFromSuperview()
        loadingSpinnerView = nil
    }
}

// MARK: - Conforming to ConfirmConsumptionTimePurchaseDisplayLogic
extension ConfirmConsumptionTimePurchaseViewController: ConfirmConsumptionTimePurchaseDisplayLogic {
    func displayPurchaseOption(_ viewModel: ConfirmConsumptionTimePurchaseModels.InitialData.ViewModel) {
        hoursLabel.text = viewModel.purchaseOption.hoursTitle
        priceLabel.text = viewModel.purchaseOption.priceTitle
        rewardLabel.text = viewModel.purchaseOption.rewardTile
    }

    func didCompletePurchase(_ viewModel: ConfirmConsumptionTimePurchaseModels.MakePurchase.ViewModel) {
        hideLoader()
        UIView.transition(with: view, duration: 0.4, options: .transitionCrossDissolve) { [weak self] in
            self?.router?.showPurchaseSuccessAlert()
        }
    }
}
