//
//  EditProfileImageData.swift
//  Flix
//
//  Created by Anton Romanov on 16.12.2021.
//

import Foundation

struct EditProfileImageData {
    // MARK: - Properties
    let id = UUID()
    let option: Option
}

extension EditProfileImageData {
    var title: String {
        switch option {
        case .change:
            return "change_profile_image_title".localized
        case .remove:
            return "remove_profile_image_title".localized
        }
    }

    var priority: Int {
        switch option {
        case .change:
            return 0
        case .remove:
            return 1
        }
    }
}

// MARK: - Hashable
extension EditProfileImageData: Hashable {
    static func ==(lhs: EditProfileImageData, rhs: EditProfileImageData) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

extension EditProfileImageData {
    enum Option {
        case change
        case remove
    }
}
