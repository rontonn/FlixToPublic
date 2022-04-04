//
//  UserSessionData.swift
//  Flix
//
//  Created by Anton Romanov on 25.01.2022.
//

import Foundation

struct UserSessionData: Codable {
    let accessToken: String
    let userData: UserData
}
