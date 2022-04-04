//
//  VideoOnDemandItem.swift
//  Flix
//
//  Created by Anton Romanov on 18.10.2021.
//

import UIKit

struct VideoOnDemandItem {
    // MARK: - Properties
    let poster: UIImage?
    let title: String
    let ratingOwner: String
    let ratingValue: Float
    let tag: Tag?
    let id = UUID()
}

// MARK: - Hashable
extension VideoOnDemandItem: Hashable {
    static func ==(lhs: VideoOnDemandItem, rhs: VideoOnDemandItem) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

extension VideoOnDemandItem {
    enum Tag: String {
        case staked = "staked_title"
        case claimed = "claimed_title"

        var associatedColor: UIColor {
            switch self {
            case .staked:
                return .orangeC08
            case .claimed:
                return .greenE00
            }
        }
        var title: String {
            return rawValue.localized
        }
    }
}
