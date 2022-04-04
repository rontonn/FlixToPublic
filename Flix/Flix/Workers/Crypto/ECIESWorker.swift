//
//  ECIESWorker.swift
//  Flix
//
//  Created by Anton Romanov on 15.01.2022.
//

import Foundation
import secp256k1

protocol ECIESWorkerLogic {
    func encrypt(msg: String, hexOfPublicKey: String) throws -> String
    func decrypt(encryptedMsg: String, hexOfPrivateKey: String) throws -> String
}

struct ECIESWorker {
}

// MARK: = ECIESWorkerLogic
extension ECIESWorker: ECIESWorkerLogic {
    func encrypt(msg: String, hexOfPublicKey: String) throws -> String {
        let publicBytesFromHex = try hexOfPublicKey.byteArray()
        let recipientPublicKey = secp256k1.Signing.PublicKey(rawRepresentation: publicBytesFromHex,
                                                             format: .uncompressed)
        let encryptedMessage = try ECIES.encrypt(msg: msg,
                                                 recipientPublicKey: recipientPublicKey.rawRepresentation.bytes)
        return encryptedMessage
    }
    
    func decrypt(encryptedMsg: String, hexOfPrivateKey: String) throws -> String {
        let privateBytesFromHex = try hexOfPrivateKey.byteArray()
        let privateKey = try secp256k1.Signing.PrivateKey(rawRepresentation: privateBytesFromHex,
                                                          format: .uncompressed)
        let decryptedMessage = try ECIES.decrypt(privateKey: privateKey.rawRepresentation.bytes,
                                                 encryptedMsg: encryptedMsg)

        return decryptedMessage
    }
}
