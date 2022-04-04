//
//  SignTypedDataTask.swift
//  Flix
//
//  Created by Anton Romanov on 03.12.2021.
//

import Foundation

enum SignTypedDataTask {
    // MARK: - Public methods
    static func signTypedData(walletConnect: WalletConnectPrivi,
                              address: String,
                              nonce: String) async throws -> String {
        let requestData = try requestData(address, nonce)
        let rawJson = try await walletConnect.eth_signTypedData(message: requestData.dataString, method: SignTypedDataReq.method)
        let signature = try parseTypedDataRsp(rawJson)
        return signature
    }
}

// MARK: - Private methods
private extension SignTypedDataTask {
    static func requestData(_ address: String, _ nonce: String) throws -> SignTypedDataReq {
        guard let reqData = SignTypedDataReq(address: address, nonce: nonce) else {
            throw PriviError(title: "SignTypedDataTask.signTypedData", msg: "Failed to get typed data.")
        }
        return reqData
    }

    static func parseTypedDataRsp(_ rawJson: String) throws -> String {
        let data = Data(rawJson.utf8)
        guard let signTypedDataRsp = RemoteRequestParser<SignTypedDataRsp>().parseFrom(data) else {
            throw PriviError(title: "SignTypedDataTask.parseTypedDataRsp", msg: "Failed to parse data to SignTypedDataRsp")
        }
        return signTypedDataRsp.result
    }
}
