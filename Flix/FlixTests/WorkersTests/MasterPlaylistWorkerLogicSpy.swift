//
//  MasterPlaylistWorkerLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 27.01.2022.
//

@testable import Flix

final class MasterPlaylistWorkerLogicSpy {
    // MARK: - Public Properties
    private (set) var isCalledGetMasterPlaylist = false
    private (set) var isCalledGetMasterPlaylistWithFakeKeyURLs = false
}

extension MasterPlaylistWorkerLogicSpy: MasterPlaylistWorkerLogic {
    func getMasterPlaylist(_ taskID: String) async throws -> String {
        isCalledGetMasterPlaylist = true
        return ""
    }

    func getMasterPlaylistWithFakeKeyURLs(_ masterPlaylist: String, _ correctURLPart: String, _ fakeURLPart: String) -> String {
        isCalledGetMasterPlaylistWithFakeKeyURLs = true
        return ""
    }
}
