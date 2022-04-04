//
//  VideoOnDemandSection.swift
//  Flix
//
//  Created by Anton Romanov on 18.10.2021.
//

import Foundation

struct VideoOnDemandSection {
    // MARK: - Properties
    let categoryTitle: String
    let items: [VideoOnDemandItem]
    let type: ContentType
    let id = UUID()
}

// MARK: - Hashable
extension VideoOnDemandSection: Hashable {
    static func ==(lhs: VideoOnDemandSection, rhs: VideoOnDemandSection) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

extension VideoOnDemandSection {
    enum ContentType {
        case movie
        case series
    }
}
