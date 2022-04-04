//
//  PlayerKeyWorker.swift
//  Flix
//
//  Created by Anton Romanov on 26.01.2022.
//

import Foundation
import BigInt

protocol PlayerKeyWorkerLogic {
    func getKeyData() async throws -> Data
}

protocol PlayerKeyWorkerData {
    var playerPrivateKeyHex: String { get }
    var playerPublicKeyHex: String { get }
    var playerSignature: String { get }
    var userID: String { get }
}

struct PlayerKeyWorker {
    // MARK: - Properties
    private let eciesWorker: ECIESWorkerLogic = ECIESWorker()
    private let wbAesWorker: WBAesWorkerLogic = WBAesWorker()

    private let keyName: String
    private let fileName: String
    private let _playerPrivateKeyHex: String
    private let _playerPublicKeyHex: String
    private let _playerSignature: String
    private let _userID: String

    // MARK: - Lifecycle
    init?(masterPlaylistURL: URL,
          keyURL: URL,
          playerPrivateKeyHex: String? = AccountsWorker.shared.playerPrivateKeyHex,
          playerPublicKeyHex: String? = AccountsWorker.shared.playerPublicKeyHex,
          playerSignature: String? = AccountsWorker.shared.playerSignature,
          userID: String? = AccountsWorker.shared.currentProfile?.userData?.id) {

        let masterPlaylistComponents = masterPlaylistURL.absoluteString.components(separatedBy: "/")
        guard let keyName = keyURL.absoluteString.components(separatedBy: "/").last,
              let fileName = masterPlaylistComponents[safe: masterPlaylistComponents.count - 2],
              let privateKeyHex = playerPrivateKeyHex,
              let playerPublicKeyHex = playerPublicKeyHex,
              let playerSignature = playerSignature,
              let userID = userID else {
            return nil
        }
        self.keyName = keyName
        self.fileName = fileName
        self._playerPrivateKeyHex = privateKeyHex
        self._playerPublicKeyHex = playerPublicKeyHex
        self._playerSignature = playerSignature
        self._userID = userID
    }
}

// MARK: - PlayerKeyWorkerData
extension PlayerKeyWorker: PlayerKeyWorkerData {
    var playerPrivateKeyHex: String {
        return _playerPrivateKeyHex
    }
    var playerPublicKeyHex: String {
        return _playerPublicKeyHex
    }
    var playerSignature: String {
        return _playerSignature
    }
    var userID: String {
       return _userID
    }
}

// MARK: - PlayerKeyWorkerLogic
extension PlayerKeyWorker: PlayerKeyWorkerLogic {
    func getKeyData() async throws -> Data {
        let taskID = "PlayerKeyWorker.getKeyData.\(keyName).\(fileName)"
        let worker = RemoteRequestWorker(dataProvider: self)
        let data = try await worker.performRequestWithRawResult(taskID, enableLogs: false)
        
        let bytesFromData = Bytes(data)
        let hexOfBytes = bytesFromData.toHexString()
        
        let decryptedEcies = try eciesWorker.decrypt(encryptedMsg: hexOfBytes, hexOfPrivateKey: playerPrivateKeyHex)

        let decryptedWbAES = try wbAesWorker.decrypt(decryptedEcies)
        
        let decryptedWbAESBytes = try wbAesWorker.bytes(from: decryptedWbAES)
    
        let keyData = Data(decryptedWbAESBytes)
        return keyData
    }
}

// MARK: - RemoteRequestWorkerDataProvider
extension PlayerKeyWorker: RemoteRequestWorkerDataProvider {
    var baseURL: String {
        return "https://e91bfd-player.myx.audio/ipfs/getKeyFile/"
    }

    var formerData: RequestFormerData {
        let path = "\(fileName)/\(userID)/\(playerPublicKeyHex)/\(playerSignature)/\(keyName)"
        let headers: [String : String] = [
            "authority" : "privi-trax-player-5ji2s.ondigitalocean.app",
            "sec-ch-ua" : "'Not;A Brand';v='99', 'Google Chrome';v='97', 'Chromium';v='97'",
            "sec-ch-ua-mobile" : "?0",
            "user-agent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.71 Safari/537.36",
            "sec-ch-ua-platform" : "macOS",
            "accept" : "*/*",
            "origin" : "https://music-app.privi.store'",
            "sec-fetch-site" : "cross-site",
            "sec-fetch-mode" : "cors",
            "sec-fetch-dest" : "empty",
            "referer" : "https://music-app.privi.store/",
            "accept-language" : "pl-PL,pl;q=0.9,en-US;q=0.8,en;q=0.7",
        ]

        let fData = RequestFormerData(path: path,
                                      method: .get,
                                      headers: headers)
        return fData
    }
}
