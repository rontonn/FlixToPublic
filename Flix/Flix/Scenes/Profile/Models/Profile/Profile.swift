//
//  Profile.swift
//  Flix
//
//  Created by Anton Romanov on 02.11.2021.
//

import UIKit

struct Profile {
    // MARK: - Properties
    let id = UUID()
    let userData: UserData?

    let subscriptionPlan: String?
    let wallet: Wallet?
    let action: Action
}

extension Profile {
    init(userData: UserData?) {
        wallet = Wallet(title: "WalletConnect", image: #imageLiteral(resourceName: "smallWalletIcon"))
        action = .edit
        self.userData = userData
        self.subscriptionPlan = "20h Watch time"
    }

    init?(_ action: Action) {
        guard action == .logout else {
            return nil
        }
        userData = nil
        wallet = nil
        subscriptionPlan = nil
        self.action = action
    }

    struct Wallet: Hashable {
        let title: String?
        let image: UIImage?
        let id = UUID()

        static func ==(lhs: Wallet, rhs: Wallet) -> Bool {
            return lhs.id == rhs.id
        }
        func hash(into hasher: inout Hasher) {
            hasher.combine(self.id)
        }
    }
}

// MARK: - Computed properties
extension Profile {
    var fullName: String {
        var fName = ""
        if let firstName = userData?.firstName, let lastName = userData?.lastName {
            fName = firstName + " " + lastName
        }
        return fName
    }

    var profileImage: URL? {
        var pImage: URL?
        if let urlIpfsImage = userData?.urlIpfsImage {
            pImage = URL(string: urlIpfsImage)
        } else if let anonAvatar = userData?.anonAvatar {
            let path = "https://privi.fra1.digitaloceanspaces.com/privi/avatars/" + anonAvatar
            pImage = URL(string: path)
        }
        return pImage
    }
}

// MARK: - Hashable
extension Profile: Hashable {
    static func ==(lhs: Profile, rhs: Profile) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

extension Profile {
    enum Action {
        case edit
        case logout

        var title: String {
            switch self {
            case .edit:
                return "edit_title".localized
            case .logout:
                return "logout_title".localized
            }
        }
    }
}
