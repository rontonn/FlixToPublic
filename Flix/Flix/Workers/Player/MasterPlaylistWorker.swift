//
//  MasterPlaylistWorker.swift
//  Flix
//
//  Created by Anton Romanov on 26.01.2022.
//

import Foundation

protocol MasterPlaylistWorkerLogic {
    func getMasterPlaylist(_ taskID: String) async throws -> String
    func getMasterPlaylistWithFakeKeyURLs(_ masterPlaylist: String, _ correctURLPart: String, _ fakeURLPart: String) -> String
}

struct MasterPlaylistWorker {
    // MARK: - Properties
    let url: String
    private var worker: RemoteRequestWorker?

    // MARK: - Lifecycle
    init(url: String) {
        self.url = url
        worker = nil
        worker = RemoteRequestWorker(dataProvider: self)
    }
}
// MARK: - MasterPlaylistWorkerLogic
extension MasterPlaylistWorker: MasterPlaylistWorkerLogic {
    func getMasterPlaylist(_ taskID: String) async throws -> String {
        guard let worker = worker else {
            throw PriviError(title: "MasterPlaylistWorker.getMasterPlaylist()", msg: "Failed to create worker for the request.")
        }
        let data = try await worker.performRequestWithRawResult(taskID, enableLogs: false)
        if let decoded = String(data: data, encoding: .utf8)?.removingPercentEncoding {
            return decoded
        } else {
            throw PriviError(title: "MasterPlaylistWorker.getMasterPlaylist()", msg: "Failed get raw response.")
        }
    }

    func getMasterPlaylistWithFakeKeyURLs(_ masterPlaylist: String,
                                          _ correctURLPart: String,
                                          _ fakeURLPart: String) -> String {
        var newMasterPlaylist = ""
        let keyMethod = "#EXT-X-KEY:METHOD"

        masterPlaylist.enumerateLines { line, _ in
            if line.contains(keyMethod) {
                let newLine = line.replacingOccurrences(of: correctURLPart, with: fakeURLPart)
                newMasterPlaylist += newLine + "\n"
            } else {
                newMasterPlaylist += line + "\n"
            }
        }
        return newMasterPlaylist
    }
}

// MARK: - RemoteRequestWorkerDataProvider
extension MasterPlaylistWorker: RemoteRequestWorkerDataProvider {
    var formerData: RequestFormerData {
        let fData = RequestFormerData(path: url,
                                      method: .get,
                                      urlType: .absolute)
        return fData
    }
}
