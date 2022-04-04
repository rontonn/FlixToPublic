//
//  SceneTab.swift
//  Flix
//
//  Created by Anton Romanov on 15.10.2021.
//

import Foundation

struct SceneTab {
    // MARK: - Properties
    let id = UUID()
    let option: Option
}

extension SceneTab {
    var title: String {
        switch option {
        case .profile:
            return "profile_title".localized
        case .series:
            return "series_title".localized
        case .movies:
            return "movie_title".localized
        case .music:
            return "music_title".localized
        case .tv:
            return "tv_title".localized
        }
    }
}

// MARK: - Hashable
extension SceneTab: Hashable {
    static func ==(lhs: SceneTab, rhs: SceneTab) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

extension SceneTab {
    enum Option {
        case profile(image: URL?)
        case series
        case movies
        case music
        case tv
    }
}
