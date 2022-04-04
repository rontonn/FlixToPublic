//
//  SignTypedDataForPlayerTask.swift
//  Flix
//
//  Created by Anton Romanov on 18.01.2022.
//

import Foundation

enum SignTypedDataForPlayerTask {
    // MARK: - Public methods
    static func signTypedData(walletConnect: WalletConnectPrivi,
                              address: String,
                              publicKey: String) async throws -> String {
        let requestData = try requestData(address, publicKey)
        let rawJson = try await walletConnect.eth_signTypedData(message: requestData.dataString, method: SignTypedDataForPlayerReq.method)
        let signature = try parseTypedDataRsp(rawJson)
        return signature
    }
}

// MARK: - Private methods
private extension SignTypedDataForPlayerTask {
    static func requestData(_ address: String, _ publicKey: String) throws -> SignTypedDataForPlayerReq {
        guard let reqData = SignTypedDataForPlayerReq(address: address, publicKey: publicKey) else {
            throw PriviError(title: "SignTypedDataForPlayerTask.signTypedData", msg: "Failed to get typed data.")
        }
        return reqData
    }

    static func parseTypedDataRsp(_ rawJson: String) throws -> String {
        let data = Data(rawJson.utf8)
        guard let signTypedDataRsp = RemoteRequestParser<SignTypedDataForPlayerRsp>().parseFrom(data) else {
            throw PriviError(title: "SignTypedDataForPlayerTask.parseTypedDataRsp.", msg: "Failed to parse data to SignTypedDataRsp")
        }
        return signTypedDataRsp.result
    }
}
