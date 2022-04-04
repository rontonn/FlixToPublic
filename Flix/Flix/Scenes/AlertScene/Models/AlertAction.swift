//
//  AlertAction.swift
//  Flix
//
//  Created by Anton Romanov on 16.12.2021.
//

import Foundation

struct AlertAction {
    // MARK: - Properties
    let id = UUID()
    let option: Option
}

// MARK: - Computed properties
extension AlertAction {
    var title: String {
        switch option {
        case .close:
            return "close_title".localized
        }
    }
}

// MARK: - Hashable
extension AlertAction: Hashable {
    static func ==(lhs: AlertAction, rhs: AlertAction) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

extension AlertAction {
    enum Option {
        case close
    }
}
