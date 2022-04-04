//
//  Keychain.swift
//  Flix
//
//  Created by Anton Romanov on 25.01.2022.
//

import Foundation

final class Keychain {
    // MARK: - Public methods
    @discardableResult
    class func save(key: Key, data: Data) -> OSStatus {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: key.rawValue,
            kSecValueData as String: data ] as [String: Any]

        SecItemDelete(query as CFDictionary)

        return SecItemAdd(query as CFDictionary, nil)
    }

    @discardableResult
    class func load(key: Key) -> Data? {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne ] as [String: Any]

        var dataTypeRef: AnyObject?

        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == noErr, let dataTypeRef = dataTypeRef as? Data {
            return dataTypeRef
        } else {
            return nil
        }
    }

    class func deleteData(for key: Key) {
        let secItemClasses = [kSecClassGenericPassword,
            kSecClassInternetPassword,
            kSecClassCertificate,
            kSecClassKey,
            kSecClassIdentity]
        
        for secItemClass in secItemClasses {
            let query: NSDictionary = [
                kSecClass as String: secItemClass,
                kSecAttrAccount as String: key.rawValue,
                kSecAttrSynchronizable as String: kSecAttrSynchronizableAny
            ]
            SecItemDelete(query)
        }
    }

    class func deleteAllStoredData() {
        for key in Key.allCases {
            deleteData(for: key)
        }
    }
}

extension Data {
    init<T>(from value: T) {
        self = withUnsafePointer(to: value) { (ptr: UnsafePointer<T>) -> Data in
            return Data(buffer: UnsafeBufferPointer(start: ptr, count: 1))
        }
    }

    func to<T>(type: T.Type) -> T {
        return self.withUnsafeBytes { $0.load(as: T.self) }
    }
}

extension Keychain {
    enum Key: String, CaseIterable {
        case playerPrivateKeyHex
        case sessionKey
        case playerSignatureKey
        case userSessionDataKey
    }
}
