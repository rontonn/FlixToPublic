//
//  EditProfileData.swift
//  Flix
//
//  Created by Anton Romanov on 03.11.2021.
//

import Foundation

struct EditProfileData {
    static let title = "edit_profile_title".localized

    // MARK: - Properties
    let id = UUID()
    let option: Option
}

extension EditProfileData {
    var title: String {
        switch option {
        case .name:
            return "name_title".localized
        case .profileImage:
            return "change_profile_image_title".localized
        case .subscriptionPlan:
            return "subscription_plan_title".localized
        }
    }

    var priority: Int {
        switch option {
        case .name:
            return 0
        case .profileImage:
            return 1
        case .subscriptionPlan:
            return 2
        }
    }
}

// MARK: - Hashable
extension EditProfileData: Hashable {
    static func ==(lhs: EditProfileData, rhs: EditProfileData) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

extension EditProfileData {
    enum Option {
        case name(_ name: String?)
        case profileImage(_ image: URL?)
        case subscriptionPlan(_ desc: String?)
    }
}
