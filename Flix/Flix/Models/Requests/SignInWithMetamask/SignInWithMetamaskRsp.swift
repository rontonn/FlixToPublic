//
//  SignInWithMetamaskRsp.swift
//  Flix
//
//  Created by Anton Romanov on 03.12.2021.
//

import Foundation

struct SignInWithMetamaskRsp: Codable {
    // MARK: - Properties
    let isSignedIn: Bool
    let userData: UserData
    let accessToken: String
}
