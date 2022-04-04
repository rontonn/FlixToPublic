//
//  SignWithMetamaskTask.swift
//  Flix
//
//  Created by Anton Romanov on 03.12.2021.
//

import Foundation

class SignWithMetamaskTask {
    // MARK: - Properties
    let address: String
    let signature: String
    private let domain: String = "Flix"
    private var worker: RemoteRequestWorker?

    // MARK: - Lifecycle
    init(address: String, signature: String) {
        self.address = address
        self.signature = signature
    }

    // MARK: - Public methods
    func signInWithMetaMaskWallet(_ taskID: String) async throws -> SignInWithMetamaskRsp {
        worker = RemoteRequestWorker(dataProvider: self)
        guard let worker = worker else {
            throw PriviError(title: "SignWithMetamaskTask.signInWithMetaMaskWallet.", msg: "Failed to create worker for the request.")
        }
        let rsp: SignInWithMetamaskRsp = try await worker.performRequest(taskID)
        return rsp
    }
}

// MARK: - RemoteRequestWorkerDataProvider
extension SignWithMetamaskTask: RemoteRequestWorkerDataProvider {
    var formerData: RequestFormerData {
        let path = "/user/signInWithMetamaskWallet_v2"
        let params = SignInWithMetamaskReq(address: address,
                                           signature: signature,
                                           domain: domain).toData()
        let fData = RequestFormerData(path: path,
                                      method: .post,
                                      parameters: params)
        return fData
    }
}
