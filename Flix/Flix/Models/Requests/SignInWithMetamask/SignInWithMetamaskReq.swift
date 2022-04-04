//
//  SignInWithMetamaskReq.swift
//  Flix
//
//  Created by Anton Romanov on 03.12.2021.
//

import Foundation

struct SignInWithMetamaskReq: Codable {
    // MARK: - Properties
    let address: String
    let signature: String
    let domain: String
}
