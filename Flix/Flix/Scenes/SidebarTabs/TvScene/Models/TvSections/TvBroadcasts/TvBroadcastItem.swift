//
//  BroadcastItem.swift
//  Flix
//
//  Created by Anton Romanov on 01.11.2021.
//

import UIKit

struct TvBroadcastItem {
    // MARK: - Properties
    let poster: UIImage?
    let title: String
    let subtitle: String
    let description: String
    let tag: Tag?
    let id = UUID()
}

// MARK: - Hashable
extension TvBroadcastItem: Hashable {
    static func ==(lhs: TvBroadcastItem, rhs: TvBroadcastItem) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

extension TvBroadcastItem {
    enum Tag {
        case live

        var image: UIImage? {
            switch self {
            case .live:
                return #imageLiteral(resourceName: "liveTagIcon")
            }
        }
    }
}
