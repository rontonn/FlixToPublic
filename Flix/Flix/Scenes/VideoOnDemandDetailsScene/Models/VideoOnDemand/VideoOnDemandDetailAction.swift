//
//  VideoOnDemandDetailsAction.swift
//  Flix
//
//  Created by Anton Romanov on 22.10.2021.
//

import Foundation

struct VideoOnDemandDetailsAction {
    // MARK: - Properties
    let id = UUID()
    let option: Option
}

extension VideoOnDemandDetailsAction {
    var title: String {
        let t: String
        switch option {
        case .play:
            t = "play_action_title"
        case .moreEpisodes:
            t = "more_episodes_action_title"
        case .watchLater:
            t = "watch_later_action_title"
        case .rate:
            t = "rate_action_title"
        }
        return t.localized
    }
}

// MARK: - Hashable
extension VideoOnDemandDetailsAction: Hashable {
    static func ==(lhs: VideoOnDemandDetailsAction, rhs: VideoOnDemandDetailsAction) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

extension VideoOnDemandDetailsAction {
    enum Option {
        case play
        case moreEpisodes
        case watchLater
        case rate
    }
}
