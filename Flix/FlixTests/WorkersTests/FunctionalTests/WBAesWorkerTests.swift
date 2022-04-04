//
//  WBAesWorkerTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 27.01.2022.
//

import XCTest
@testable import Flix

final class WBAesWorkerTests: XCTestCase {

    // MARK: - Properties
    private var wbAesWorker: WBAesWorkerLogic!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        wbAesWorker = WBAesWorker()
    }

    override func tearDown() {
        wbAesWorker = nil

        super.tearDown()
    }

    // MARK: - Public Methods
    func testDecryption() {
        let eciesDecryptedBytes: [UInt8] = [24,38,195,164,17,24,38,195,164,17,24,38,195,164,17,24,38,195,164,17,195,164,83,194,173,195,128,195,185,195,130,5,194,165,194,186,195,183,4,114,112,195,178,59,53,25,33,195,176,195,163,194,164,194,147,195,173,194,133,194,181,195,150,65,194,188,109,67,194,179,195,183,194,138,194,172,101,194,145,9,37,112,32,58,195,179,101,82,5,124,195,147,58,19,194,163,56,195,143,104,37,194,163,194,163,195,161,195,163]

        let correctDecryptedHex = "123372c29bc395c3b86ac2b2c2a9372ec2855a75c39dc28e"
        let correctDecryptedBytes: [UInt8] = [18, 51, 114, 194, 155, 195, 149, 195, 184, 106, 194, 178, 194, 169, 55, 46, 194, 133, 90, 117, 195, 157, 194, 142]
        do {
            let cipherText = String(decoding: Data(eciesDecryptedBytes), as: UTF8.self)
            let decrypted = try wbAesWorker.decrypt(cipherText)

            let hex = try hexOf(decrypted)
            XCTAssertTrue(hex == correctDecryptedHex, "WBAes decrypted msg has wrong hex.")

            let bytes = try bytesOf(decrypted)
            XCTAssertTrue(bytes == correctDecryptedBytes, "WBAes decrypted msg has wrong bytes form.")

        } catch {
            print("WBAes decryption error: \(error.localizedDescription)")
        }
    }
}

extension WBAesWorkerTests {
    func hexOf(_ txt: String) throws -> String {
        guard let msgData = txt.data(using: .utf8) else {
            throw PriviError(title: "WBAesWorkerTests.hexOf", msg: "Failed to create data from txt.")
        }
        return msgData.toHexString()
    }

    func bytesOf(_ txt: String) throws -> [UInt8] {
        guard let msgData = txt.data(using: .utf8) else {
            throw PriviError(title: "WBAesWorkerTests.bytesOf", msg: "Failed to create data from txt.")
        }
        return [UInt8](msgData)
    }
}
