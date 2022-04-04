//
//  UserData.swift
//  Flix
//
//  Created by Anton Romanov on 07.12.2021.
//

import Foundation

struct UserData: Codable {
    let creds: Int
    let lastUpdate: Int
    let lastName: String
    let isEmailValidated: Bool
//        let awards: Codable
    let facebook: String
    let hasPhoto: Bool
    let urlSlug: String
//        let myNFTPods: Codable
    let level: Int
    let id: String
    let pubKey: String
    let firstName: String
    let trustScore: Double
    let points: Int
    let address: String
    let dob: Int
    let twitter: String
//        let followings: Codable
    let role: String
    let userAddress: String
    let endorsementScore: Double
    let mnemonic: String
//        let notifications: Codable
    let walletAddresses: [String]
    let numFollowings: Int
    let tutorialsSeen: TutorialsSeen
//        let investedNFTPods: Codable
    let anon: Bool
//        let investedFTPods: Codable
    let instagram: String
//        let followingNFTPods: Codable
    let numFollowers: Int
    let validationSecret: String
//        let myFTPods: Codable
    let verified: Bool
//        let followingFTPods: Codable
//        let badges: Codable
    let anonAvatar: String
    let urlIpfsImage: String?
}

extension UserData {
    struct TutorialsSeen: Codable {
        let communities: Bool
        let pods: Bool
        let creditPools: Bool
    }
}
