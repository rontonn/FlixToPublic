//
//  Season.swift
//  Flix
//
//  Created by Anton Romanov on 26.11.2021.
//
import Foundation

struct Season: Hashable {
    let title: String
    let subtitle: String
    let id = UUID()

    // MARK: - Hashable
    static func ==(lhs: Season, rhs: Season) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    //
}
