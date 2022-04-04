//
//  SignInOption.swift
//  FlixAR
//
//  Created by Anton Romanov on 14.10.2021.
//

import Foundation

struct SignInOption {
    // MARK: - Properties
    let id = UUID()
    let option: Option
}

extension SignInOption {
    var title: String {
        switch option {
        case .wallet:
            return "sign_in_wallet_title".localized
        case .qr:
            return "sign_in_qr_title".localized
        }
    }
}

// MARK: - Hashable
extension SignInOption: Hashable {
    static func ==(lhs: SignInOption, rhs: SignInOption) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

extension SignInOption {
    enum Option {
        case wallet
        case qr
    }
}
