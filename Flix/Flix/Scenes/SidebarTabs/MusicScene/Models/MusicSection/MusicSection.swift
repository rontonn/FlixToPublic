//
//  MusicSection.swift
//  Flix
//
//  Created by Anton Romanov on 26.10.2021.
//

import Foundation

struct MusicSection {
    // MARK: - Properties
    let categoryTitle: String
    let items: [MusicItem]
    let id = UUID()
}

// MARK: - Hashable
extension MusicSection: Hashable {
    static func ==(lhs: MusicSection, rhs: MusicSection) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}
