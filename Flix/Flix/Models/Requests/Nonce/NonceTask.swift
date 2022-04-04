//
//  NonceTask.swift
//  Flix
//
//  Created by Anton Romanov on 03.12.2021.
//

import Foundation

class NonceTask {
    // MARK: - Properties
    let address: String
    private var worker: RemoteRequestWorker?

    // MARK: - Lifecycle
    init(address: String) {
        self.address = address
    }

    // MARK: - Public methods
    func randomNonce(_ taskID: String) async throws -> NonceRsp {
        worker = RemoteRequestWorker(dataProvider: self)
        guard let worker = worker else {
            throw PriviError(title: "NonceTask.randomNonce.", msg: "Failed to create worker for the request.")
        }
        let rsp: NonceRsp = try await worker.performRequest(taskID)
        return rsp
    }
}

// MARK: - RemoteRequestWorkerDataProvider
extension NonceTask: RemoteRequestWorkerDataProvider {
    var formerData: RequestFormerData {
        let path = "/user/requestSignInUsingRandomNonce"
        let params = NonceReq(address: address).toData()
        let fData = RequestFormerData(path: path,
                                      method: .post,
                                      parameters: params)
        return fData
    }
}
