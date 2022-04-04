//
//  MusicItem.swift
//  Flix
//
//  Created by Anton Romanov on 26.10.2021.
//

import UIKit

struct MusicItem {
    // MARK: - Properties
    let poster: UIImage?
    let title: String
    let artist: String
    let album: String
    let tag: Tag?
    let id = UUID()
}

// MARK: - Hashable
extension MusicItem: Hashable {
    static func ==(lhs: MusicItem, rhs: MusicItem) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

extension MusicItem {
    enum Tag: String {
        case pop = "pop_title"

        var associatedColor: UIColor {
            switch self {
            case .pop:
                return UIColor.white.withAlphaComponent(0.3)
            }
        }
        var title: String {
            return rawValue.localized
        }
    }
}
