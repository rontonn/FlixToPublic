//
//  WalletConnect.swift
//  Flix
//
//  Created by Anton Romanov on 30.11.2021.
//

import Foundation

// MARK: - WalletConnectDelegate
@MainActor
protocol WalletConnectDelegate: AnyObject {
    func failedToConnect()
    func didConnect()
    func didDisconnect()
}

final class WalletConnectPrivi {
    // MARK: - Properties
    private var client: Client?
    private var session: Session?
    private var wcURL: WCURL?
    private let bridgeURL = URL(string: "wss://wc-bridge-5qt5i.ondigitalocean.app")!
    private let metaURL = URL(string: "https://flix.privi.store/")!
    weak var delegate: WalletConnectDelegate?

    let sessionKey = "sessionKey"

    // MARK: - Lifecycle
    init(delegate: WalletConnectDelegate?) {
        self.delegate = delegate
        createWCURL()
    }

    // MARK: - Public methods
    func connect() {
        guard client == nil else {
            reconnectIfNeeded()
            return
        }
        guard let wcURL = wcURL else {
            return
        }
        client = createClient()

        do {
            try client?.connect(to: wcURL)
        } catch {
            print(" WalletConnectPrivi: error ocured on 'client.connect': \(error.localizedDescription)")
        }
    }

    func reconnectIfNeeded() {
        if let oldSessionData = Keychain.load(key: Keychain.Key.sessionKey),
           let session = try? JSONDecoder().decode(Session.self, from: oldSessionData) {
            client = Client(delegate: self, dAppInfo: session.dAppInfo)
            do {
                try client?.reconnect(to: session)
            } catch {
                print(" WalletConnectPrivi: Failed to reconnect to wallet. Error: \(error.localizedDescription).")
            }
        }
    }

    func disconnect() {
        guard let session = session else {
            return
        }
        do {
            try client?.disconnect(from: session)
        } catch {
            print(" WalletConnectPrivi: Failed to disconnect from wallet. Error: \(error.localizedDescription).")
        }
    }

    func eth_signTypedData(message: String,
                           method: String) async throws -> String {
        guard let url = session?.url,
              let account = account,
              let client = client else {
            throw PriviError(title: "WalletConnectPrivi.eth_signTypedData", msg: "Failed to get session data.")
        }
        let typedData: String = try await signTypedDataWithContinuation(url, account, client, method, message)
        return typedData
    }
}

// MARK: - Private methods
private extension WalletConnectPrivi {
    func createWCURL() {
        guard let key = randomKey() else {
            return
        }
        let topic = UUID().uuidString
        wcURL = WCURL(topic: topic,
                      bridgeURL: bridgeURL,
                      key: key)
    }

    // https://developer.apple.com/documentation/security/1399291-secrandomcopybytes
    func randomKey() -> String? {
        var rKey: String?
        var bytes = [Int8](repeating: 0, count: 32)
        let status = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
        if status == errSecSuccess {
            rKey =  Data(bytes: bytes, count: 32).toHexString()
        }
        return rKey
    }

    func createClient() -> Client? {
        let clientMeta = Session.ClientMeta(name: "Flix",
                                            description: "Flix tvOS dapp",
                                            icons: [],
                                            url: metaURL)
        let dAppInfo = Session.DAppInfo(peerId: UUID().uuidString, peerMeta: clientMeta)
        let client = Client(delegate: self, dAppInfo: dAppInfo)
        return client
    }

    func signTypedDataWithContinuation(_ url: WCURL, _ account: String, _ client: Client, _ method: String, _ message: String) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            do {
                try client.eth_signTypedData(url: url, method: method, account: account, message: message) { rsp in
                    do {
                        let rawJson = try rsp.json().string
                        continuation.resume(returning: rawJson)
                    } catch {
                        continuation.resume(throwing: PriviError(title: "WalletConnectPrivi.eth_signTypedData", msg: error.localizedDescription))
                    }
                }
            } catch {
                continuation.resume(throwing: PriviError(title: "WalletConnectPrivi.eth_signTypedData", msg: error.localizedDescription))
            }
        }
    }
}

// MARK: - Computed properties
extension WalletConnectPrivi {
    var connectionURL: String? {
        return wcURL?.absoluteString
    }

    var account: String? {
        return session?.walletInfo?.accounts.first
    }
}

// MARK: - ClientDelegate
extension WalletConnectPrivi: ClientDelegate {
    func client(_ client: Client, didFailToConnect url: WCURL) {
        Task { @MainActor in
            delegate?.failedToConnect()
        }
    }

    func client(_ client: Client, didConnect session: Session) {
        self.session = session
        do {
            let sessionData = try JSONEncoder().encode(session)
            Keychain.save(key: Keychain.Key.sessionKey, data: sessionData)
        } catch {
            print(" WalletConnectPrivi: Failed to save session. Error: \(error.localizedDescription)")
        }
        Task { @MainActor in
            delegate?.didConnect()
        }
    }

    func client(_ client: Client, didDisconnect session: Session) {
        Keychain.deleteData(for: Keychain.Key.sessionKey)
        self.session = nil
        Task { @MainActor in
            delegate?.didDisconnect()
        }
    }
}
