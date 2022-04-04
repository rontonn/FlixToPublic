//
//  PriviErrorAction.swift
//  Flix
//
//  Created by Anton Romanov on 16.12.2021.
//

import Foundation

struct PriviErrorAction {
    // MARK: - Properties
    let id = UUID()
    let option: Option
}

// MARK: - Computed properties
extension PriviErrorAction {
    var title: String {
        switch option {
        case .close:
            return "close_title".localized
        case .solution:
            return "Solution is here."
        }
    }
}

// MARK: - Hashable
extension PriviErrorAction: Hashable {
    static func ==(lhs: PriviErrorAction, rhs: PriviErrorAction) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

extension PriviErrorAction {
    enum Option {
        case close
        case solution
    }
}
