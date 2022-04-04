//
//  SeriesSection.swift
//  Flix
//
//  Created by Anton Romanov on 26.11.2021.
//

import Foundation

struct SeriesSection {
    // MARK: - Properties
    let series: [Seria]
    let id = UUID()
}

// MARK: - Hashable
extension SeriesSection: Hashable {
    static func ==(lhs: SeriesSection, rhs: SeriesSection) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}
