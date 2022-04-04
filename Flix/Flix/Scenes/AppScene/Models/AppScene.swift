//
//  
//  AppScene.swift
//  FlixAR
//
//  Created by Anton Romanov on 12.10.2021.
//
//

import UIKit

enum AppScene: String {
    case launch = "Launch"
    case home = "Home"
    // Tabs
    case movies = "Movies"
    case series = "Series"
    case music = "Music"
    case tv = "Tv"
    // - Auth
    case profiles = "Profiles"
    case editProfile = "EditProfile"
    case editName = "EditName"
    case editProfileImage = "EditProfileImage"
    case editConsumptionTime = "EditConsumptionTime"
    case purchaseConsumptionTime = "PurchaseConsumptionTime"
    case confirmConsumptionTimePurchase = "ConfirmConsumptionTimePurchase"
    case signIn = "SignIn"
    case signInWallet = "SignInWallet"
    //
    //
    case videoOnDemandDetails = "VideoOnDemandDetails"
    case moreEpisodes = "MoreEpisodes"
    case error = "Error"
    case alert = "Alert"
    case contentPlayer = "ContentPlayer"
}

extension AppScene {
    // MARK: - Properties
    var storyboard: UIStoryboard {
        return UIStoryboard(name: rawValue, bundle: Bundle.main)
    }
    var identifier: String {
        switch self {
        case .launch:
            return String(describing: LaunchViewController.self)
        case .home:
            return String(describing: HomeViewController.self)
        case .profiles:
            return String(describing: ProfilesViewController.self)
        case .editProfile:
            return String(describing: EditProfileViewController.self)
        case .editName:
            return String(describing: EditNameViewController.self)
        case .editProfileImage:
            return String(describing: EditProfileImageViewController.self)
        case .editConsumptionTime:
            return String(describing: EditConsumptionTimeViewController.self)
        case .purchaseConsumptionTime:
            return String(describing: PurchaseConsumptionTimeViewController.self)
        case .confirmConsumptionTimePurchase:
            return String(describing: ConfirmConsumptionTimePurchaseViewController.self)
        case .signIn:
            return String(describing: SignInViewController.self)
        case .signInWallet:
            return String(describing: SignInWalletViewController.self)
        case .movies:
            return String(describing: MoviesViewController.self)
        case .series:
            return String(describing: SeriesViewController.self)
        case .music:
            return String(describing: MusicViewController.self)
        case .tv:
            return String(describing: TvViewController.self)
        case .videoOnDemandDetails:
            return String(describing: VideoOnDemandDetailsViewController.self)
        case .moreEpisodes:
            return String(describing: MoreEpisodesViewController.self)
        case .error:
            return String(describing: ErrorViewController.self)
        case .alert:
            return String(describing: AlertViewController.self)
        case .contentPlayer:
            return String(describing: ContentPlayerViewController.self)
        }
    }

    // MARK: - Public Methods
    func viewController<T: UIViewController>(_ type: T.Type) -> T? {
        guard let controller = storyboard.instantiateViewController(withIdentifier: self.identifier) as? T else {
            print("\(String(describing: AppScene.self)): Failed to UIViewController with identifier \(self.identifier).")
            return nil
        }
        return controller
    }
}
