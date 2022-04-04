//
//  TvChannelsSection.swift
//  Flix
//
//  Created by Anton Romanov on 01.11.2021.
//

import Foundation

struct TvChannelsSection {
    // MARK: - Properties
    let categoryTitle: String
    let items: [TvChannelItem]
    let id = UUID()
}

// MARK: - Hashable
extension TvChannelsSection: Hashable {
    static func ==(lhs: TvChannelsSection, rhs: TvChannelsSection) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}
