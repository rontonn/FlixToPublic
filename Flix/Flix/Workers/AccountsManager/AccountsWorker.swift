//
//  AccountsWorker.swift
//  Flix
//
//  Created by Anton Romanov on 07.12.2021.
//

import Foundation
import secp256k1

@MainActor
protocol AccountsWorkerDelegate: AnyObject {
    func onConnect()
    func onDisconnect()
    func onAuthorise()
    func onFailure(_ error: PriviError)
}

typealias AccountsWorkable = AccountsWorkerLogic & AccountsWorkerData

protocol AccountsWorkerData {
    var connectionURL: String? { get }
    var profiles: [Profile] { get }
    var currentProfile: Profile? { get }
    var isAuthorised: Bool { get }
    var playerPrivateKeyHex: String? { get }
    var playerPublicKeyHex: String? { get }
    var playerSignature: String? { get set }
}

protocol AccountsWorkerLogic {
    func update(delegate: AccountsWorkerDelegate)
    func connect()
    func disconnect()
    func reconnect()
    func retrievePlayerKey() throws
}

final class AccountsWorker {
    // MARK: - Properties
    static let shared: AccountsWorkable = AccountsWorker()

    private weak var delegate: AccountsWorkerDelegate?
    private var userSessionData: UserSessionData?
    private var playerKey: secp256k1.Signing.PrivateKey?
    private var walletConnect: WalletConnectPrivi?

    var playerSignature: String?

    private var nonceTask: NonceTask?
    private var signWithMetamaskTask: SignWithMetamaskTask?

    // MARK: - Lifecycle
    private init() {
    }
}

// MARK: - AccountsWorkerLogic
extension AccountsWorker: AccountsWorkerData {
    var connectionURL: String? {
        return walletConnect?.connectionURL
    }

    var profiles: [Profile] {
        var p: [Profile] = []
        if let userData = userSessionData?.userData {
            let newProfile = Profile(userData: userData)
            p.append(newProfile)
        }
        return p
    }

    var currentProfile: Profile? {
        return profiles.first
    }

    var isAuthorised: Bool {
        return currentProfile != nil
    }

    var playerPrivateKeyHex: String? {
        return playerKey?.rawRepresentation.toHexString()
    }

    var playerPublicKeyHex: String? {
        return playerKey?.publicKey.rawRepresentation.toHexString()
    }
}

// MARK: - AccountsWorkerLogic
extension AccountsWorker: AccountsWorkerLogic{
    func update(delegate: AccountsWorkerDelegate) {
        self.delegate = delegate
    }

    func connect() {
        createWalletConnectIfNeeded()
        walletConnect?.connect()
    }

    func disconnect() {
        walletConnect?.disconnect()
    }

    func reconnect() {
        try? retrievePlayerSignature()
        try? retrieveUserSessionData()
        createWalletConnectIfNeeded()
        walletConnect?.reconnectIfNeeded()
    }

    func retrievePlayerKey() throws {
        if let playerPrivateKeyHexData = Keychain.load(key: Keychain.Key.playerPrivateKeyHex) {
            let playerPrivateKeyHex = try JSONDecoder().decode(String.self, from: playerPrivateKeyHexData)
            let playerPrivateKeyBytes = try playerPrivateKeyHex.byteArray()

            playerKey = try secp256k1.Signing.PrivateKey(rawRepresentation: playerPrivateKeyBytes)
        } else {
            try createPlayerKey()
        }
    }
}

// MARK: - Private methods
private extension AccountsWorker {
    func createWalletConnectIfNeeded() {
        if walletConnect == nil {
            self.walletConnect = WalletConnectPrivi(delegate: self)
        }
    }

    func authorise() async throws {
        guard let walletConnect = walletConnect,
              let address = walletConnect.account else {
            throw PriviError(title: "AccountsWorker.authorise", msg: "Failed to get wallet account/address.")
        }

        let nonce = try await randomNonce(address)
        let signature = try await SignTypedDataTask.signTypedData(walletConnect: walletConnect, address: address, nonce: nonce)
        try await signInWithMetamask(address, signature: signature)
        try await signatureForPlayer(walletConnect, address)

        await delegate?.onAuthorise()
        self.nonceTask = nil
    }

    func randomNonce(_ address: String) async throws -> String {
        nonceTask = NonceTask(address: address)

        guard let nonceTask = nonceTask else {
            throw PriviError(title: "AccountsWorker.randomNonce", msg: "Failed to create nonce task.")
        }
        let taskID = "AccountsWorker.randomNonce.\(address)"
        let nonceRsp = try await nonceTask.randomNonce(taskID)

        return nonceRsp.nonce
    }

    func signInWithMetamask(_ address: String, signature: String) async throws {
        signWithMetamaskTask = SignWithMetamaskTask(address: address,
                                                    signature: signature)
        guard let signWithMetamaskTask = signWithMetamaskTask else {
            throw PriviError(title: "AccountsWorker.signInWithMetamask", msg: "Failed to create signInWithMetamask task.")
        }

        let taskID = "AccountsWorker.signInWithMetamask"
        let signInMetamaskRsp = try await signWithMetamaskTask.signInWithMetaMaskWallet(taskID)
        userSessionData = UserSessionData(accessToken: signInMetamaskRsp.accessToken,
                                          userData: signInMetamaskRsp.userData)
        
        try saveUserSessionData()
        self.signWithMetamaskTask = nil
    }

    func signatureForPlayer(_ walletConnect: WalletConnectPrivi, _ address: String) async throws {
        guard let playerPublicKeyHex = playerPublicKeyHex else {
            throw PriviError(title: "AccountsWorker.signatureForPlayer", msg: "Failed to get playerPublicKeyHex.")
        }
        playerSignature = try await SignTypedDataForPlayerTask.signTypedData(walletConnect: walletConnect, address: address, publicKey: playerPublicKeyHex)
        try savePlayerSignature()
    }

    func checkError(_ error: Error) -> PriviError {
        let priviError: PriviError
        if let prError = error as? PriviError {
            priviError = prError
        } else {
            priviError = PriviError(title: "AccountsWorker.checkError", msg: error.localizedDescription)
        }
        return priviError
    }

    func createPlayerKey() throws {
        playerKey = try secp256k1.Signing.PrivateKey()
        try savePlayerKey()
    }

    func savePlayerKey() throws {
        if let playerPrivateKeyHex = playerPrivateKeyHex {
            let keyData = try JSONEncoder().encode(playerPrivateKeyHex)
            Keychain.save(key: Keychain.Key.playerPrivateKeyHex, data: keyData)
        }
    }

    func savePlayerSignature() throws {
        if let playerSignature = playerSignature {
            let playerSignatureData = try JSONEncoder().encode(playerSignature)
            Keychain.save(key: Keychain.Key.playerSignatureKey, data: playerSignatureData)
        }
    }

    func retrievePlayerSignature() throws {
        if let playerSignatureData = Keychain.load(key: Keychain.Key.playerSignatureKey) {
            let playerSignature = try JSONDecoder().decode(String.self, from: playerSignatureData)

            self.playerSignature = playerSignature
        }
    }

    func saveUserSessionData() throws {
        if let userSessionData = userSessionData {
            let userSessionDataEncoded = try JSONEncoder().encode(userSessionData)
            Keychain.save(key: Keychain.Key.userSessionDataKey, data: userSessionDataEncoded)
        }
    }

    func retrieveUserSessionData() throws {
        if let userSessionData = Keychain.load(key: Keychain.Key.userSessionDataKey) {
            let userSessionDataDecoded = try JSONDecoder().decode(UserSessionData.self, from: userSessionData)

            self.userSessionData = userSessionDataDecoded
        }
    }
}

// MARK: - WalletConnectDelegate
extension AccountsWorker: WalletConnectDelegate {
    func failedToConnect() {
        let error = PriviError(title: "AccountsWorker.failedToConnect", msg: "Failed to connect to the wallet.")
        delegate?.onFailure(error)
    }

    func didConnect() {
        delegate?.onConnect()
        if userSessionData == nil || playerSignature == nil {
            Task(priority: .userInitiated) {
                do {
                    try await authorise()
                } catch {
                    let priviError = checkError(error)
                    delegate?.onFailure(priviError)
                    nonceTask = nil
                    signWithMetamaskTask = nil
                }
            }
        }
    }

    func didDisconnect() {
        walletConnect = nil
        playerSignature = nil
        userSessionData = nil
        Keychain.deleteData(for: Keychain.Key.userSessionDataKey)
        Keychain.deleteData(for: Keychain.Key.playerSignatureKey)

        nonceTask = nil
        signWithMetamaskTask = nil
        delegate?.onDisconnect()
    }
}

// MARK: - NSCopying
extension AccountsWorker: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
