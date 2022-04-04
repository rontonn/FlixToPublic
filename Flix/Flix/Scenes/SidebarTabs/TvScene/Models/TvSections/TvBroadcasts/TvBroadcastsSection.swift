//
//  TvBroadcastsSection.swift
//  Flix
//
//  Created by Anton Romanov on 01.11.2021.
//

import Foundation
import UIKit

struct TvBroadcastsSection {
    // MARK: - Properties
    let header: Header
    let items: [TvBroadcastItem]
    let id = UUID()
}

// MARK: - Hashable
extension TvBroadcastsSection: Hashable {
    static func ==(lhs: TvBroadcastsSection, rhs: TvBroadcastsSection) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

extension TvBroadcastsSection {
    struct Header {
        let tag: String?
        let stream: String?
        let categories: String?
        let title:  String?
    }
}
