//
//  PlayerKeyWorkerTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 27.01.2022.
//

import XCTest
@testable import Flix

final class PlayerKeyWorkerTests: XCTestCase {

    // MARK: - Properties
    private var playerKeyWorker: PlayerKeyWorkerLogic!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        playerKeyWorker = PlayerKeyWorker(masterPlaylistURL: URL(string: "https://elb.ipfsprivi.com:8080/ipfs/QmWFnFCfoHiQVcabfWdYdguqPjvQ6xjv9qwcNiozJcAGNk/master.m3u8")!,
                                          keyURL: URL(string: "fakefake://elb.ipfsprivi.com:8080/ipfs/QmcCFEeoQF6FLFpobaf42b5AiRvLDmmzUYnMq4EQctq8f5/enc3.key")!,
                                          playerPrivateKeyHex: "257772ec7cf83b3bb3e47ee53e1944e607036314eac641a542949647d6929137",
                                          playerPublicKeyHex: "0232e9661a0f0cf7e4e561710adc518476f345eedb6cade1f1a2a17a287b895fa1",
                                          playerSignature: "0xe47d560022f34e9d2b0eecd7a2e7050ad600b375c6a8fd4a9861c72d5d5213e44d1d98559282dbbc4f7c13f993f5e98dc5fe09402337fa03fdf7e17ce3c466251b",
                                          userID: "2K0HIrP36qcAnQyH5zgt")
    }

    override func tearDown() {
        playerKeyWorker = nil

        super.tearDown()
    }

    // MARK: - Public Methods
    func testEncryption() async {
        do {
            let data = try await playerKeyWorker.getKeyData()
            XCTAssertTrue(data.count == 16, "Data has wrong length.")
        } catch {
            print("PlayerKeyWorker getKeyData error: \(error.localizedDescription)")
        }
    }
}
