//
//  Seria.swift
//  Flix
//
//  Created by Anton Romanov on 26.11.2021.
//
import UIKit

struct Seria: Hashable {
    let posterImage: String
    let seasonNumber: String
    let seriaNumber: String
    let duration: String
    let seriaTitle: String
    let description: String
    let progress: CGFloat

    let id = UUID()

    // MARK: - Hashable
    static func ==(lhs: Seria, rhs: Seria) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    //
}
