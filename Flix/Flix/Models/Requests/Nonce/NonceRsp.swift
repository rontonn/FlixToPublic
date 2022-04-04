//
//  NonceRsp.swift
//  Flix
//
//  Created by Anton Romanov on 03.12.2021.
//

import Foundation

struct NonceRsp: Codable {
    // MARK: - Properties
    let success: Bool
    let nonce: String
}
