//
//  SeasonSection.swift
//  Flix
//
//  Created by Anton Romanov on 26.11.2021.
//

import Foundation

struct SeasonSection {
    // MARK: - Properties
    let seasons: [Season]
    let id = UUID()
}

// MARK: - Hashable
extension SeasonSection: Hashable {
    static func ==(lhs: SeasonSection, rhs: SeasonSection) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}
