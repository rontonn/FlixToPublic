//
//  ECIES.swift
//  Flix
//
//  Created by Anton Romanov on 15.01.2022.
//

import Foundation
import secp256k1
import CryptoSwift
import BigInt

enum ECIES {
    // MARK: - Properties
    private static let parityDefaultHMAC: Bytes = [0, 0]

    // MARK: - Public static methods
    static func encrypt(msg: String, recipientPublicKey: Bytes, options: Options? = nil) throws -> String {
        let errorTitle = "ECIES.encrypt error."
        guard let msgData = msg.data(using: .utf8) else {
            throw PriviError(title: errorTitle, msg: "Failed to create data from mesage.")
        }
        guard let randomEphemKey = try? secp256k1.Signing.PrivateKey(format: .uncompressed) else {
            throw PriviError(title: errorTitle, msg: "Failed to create EPHEM key.")
        }
        let sharedPx = try getSharedSecret(privateKey: randomEphemKey.rawRepresentation.bytes,
                                           publicKey: recipientPublicKey)

        let hash = kdf(secret: sharedPx, outputLength: 32)

        let hashParts = try partsOfHash(hash)

        let msgBytes = Bytes(msgData)
        let iv = AES.randomIV(16)

        let aesEncrypted = try aesEncryptMessage(msgBytes,
                                                 encryptionKey: hashParts.encryptionKey,
                                                 iv: iv)
        let hmac = try hmacForEncryption(iv: iv,
                                         encryptedMsg: aesEncrypted,
                                         rawMacKey: hashParts.rawMackKey)
        
        let fullEncryptedMessage = randomEphemKey.publicKey.rawRepresentation.bytes + iv + aesEncrypted + hmac
        return fullEncryptedMessage.toHexString()
    }

    static func decrypt(privateKey: Bytes, encryptedMsg: String) throws -> String {
        let errorTitle = "ECIES.decrypt error."
        let encryptedBytes = try encryptedMsg.byteArray()

        let encryptedMsgLength = encryptedBytes.count
        let metaLength = 1 + 64 + 16 + 32
        
        guard encryptedMsgLength > metaLength else {
            throw PriviError(title: errorTitle, msg: "Data is too small")
        }
        guard let firstEncryptedByte = encryptedBytes[safe: 0],
              firstEncryptedByte >= 2 && firstEncryptedByte <= 4 else {
            throw PriviError(title: errorTitle, msg: "Not valid cipher text.")
        }

        let cipherTextLength = encryptedMsgLength - metaLength

        guard let ephemPublicKey = encryptedBytes[safe: 0...64] else {
            throw PriviError(title: errorTitle, msg: "Failed to get ephemPublicKey.")
        }
        guard let iv = encryptedBytes[safe: 65...65+15] else {
            throw PriviError(title: errorTitle, msg: "Failed to get IV.")
        }
        guard let cipherAndIv = encryptedBytes[safe: 65...65+15+cipherTextLength] else {
            throw PriviError(title: errorTitle, msg: "Failed to get cipher and IV.")
        }
        guard let cipherText = cipherAndIv[safe: 16...] else {
            throw PriviError(title: errorTitle, msg: "Failed to get cipher text.")
        }
        guard let msgMac = encryptedBytes[safe: (65+16+cipherTextLength)...] else {
            throw PriviError(title: errorTitle, msg: "Failed to get msgMac.")
        }
        let px = try getSharedSecret(privateKey: privateKey,
                                     publicKey: ephemPublicKey)
        let hash = kdf(secret: px, outputLength: 32)

        let hashParts = try partsOfHash(hash)

        let currentHMAC = try hmacForDecryption(cipherAndIv: cipherAndIv,
                                                rawMacKey: hashParts.rawMackKey)

        guard equalConstTime(currentHMAC, msgMac) else {
            throw PriviError(title: errorTitle, msg: "Incorrect MAC.")
        }
        
        let decrypted = try aesDecryptMessage(cipherText,
                                              encryptionKey: hashParts.encryptionKey,
                                              iv: iv)
        let decryptedText = String(decoding: Data(decrypted), as: UTF8.self)
        return decryptedText
    }

    private static func equalConstTime(_ b1: Bytes, _ b2: Bytes) -> Bool {
        if (b1.count != b2.count) {
          return false
        }
        var res = 0
        for i in 0..<b1.count {
          res |= Int(b1[i]) ^ Int(b2[i])
        }
        return res == 0
    }
}

// MARK: - Private static methods
extension ECIES {
    private static func getSharedSecret(privateKey: Bytes, publicKey: Bytes) throws -> Bytes {
        let bPoint = try CurvePoint.create(from: publicKey)
        let aBInt = try CurvePoint.bytesToNumber(privateKey)
        let secretPoint = try bPoint.multiply(aBInt)

        let secretPointCompressedHex = try secretPoint.toHex(true)
        let bytesFromHex = try secretPointCompressedHex.byteArray()

        return bytesFromHex
    }

    private static func kdf(secret: Bytes, outputLength: Int) -> Bytes {
        var ctr: UInt8 = 1
        var written = 0
        var result = Bytes()
        
        while written < outputLength {
            let ctrs: Bytes = [ctr >> 24, ctr >> 16, ctr >> 8, ctr]
            
            let hashResult = Digest.sha256(ctrs + secret)

            result += hashResult
            written += 32
            ctr += 1
        }
        return result
    }

    private static func partsOfHash(_ hash: Bytes) throws -> (encryptionKey: Bytes, rawMackKey: Bytes) {
        guard let encryptionKey = hash[safe: 0...15],
              let rawMackKey = hash[safe: 16...31] else {
                  throw PriviError(title: "ECIES.partsOfHash error.", msg: "Failed to get parts from hash.")
              }
        return (encryptionKey, rawMackKey)
    }

    private static func aesEncryptMessage(_ msgBytes: Bytes, encryptionKey: Bytes, iv: Bytes) throws -> Bytes {
        let aes = try AES(key: encryptionKey, blockMode: CTR(iv: iv), padding: .noPadding)
        let cipherText = try aes.encrypt(msgBytes)
        return cipherText
    }

    private static func hmacForEncryption(iv: Bytes, encryptedMsg: Bytes, rawMacKey: Bytes) throws -> Bytes {
        let macKey = Digest.sha256(rawMacKey)
        let dataToMac = iv + encryptedMsg + parityDefaultHMAC
        let hmac = try hmac(macKey, dataToMac)
        return hmac
    }

    private static func hmacForDecryption(cipherAndIv: Bytes, rawMacKey: Bytes) throws -> Bytes {
        let macKey = Digest.sha256(rawMacKey)
        let dataToMac = cipherAndIv + parityDefaultHMAC
        let hmac = try hmac(macKey, dataToMac)
        return hmac
    }

    private static func hmac(_ macKey: Bytes, _ dataToMac: Bytes) throws -> Bytes {
        let hmacRaw = HMAC(key: macKey, variant: .sha256)
        let hmac = try hmacRaw.authenticate(dataToMac)
        return hmac
    }

    private static func aesDecryptMessage(_ ciphertext: Bytes, encryptionKey: Bytes, iv: Bytes) throws -> Bytes {
        let aes = try AES(key: encryptionKey, blockMode: CTR(iv: iv), padding: .noPadding)
        let decrypted = try aes.decrypt(ciphertext)
        return decrypted
    }
}

extension ECIES {
    struct Options {
        let iv: Bytes?
        let ephemPrivateKey: Bytes?
    }
}
