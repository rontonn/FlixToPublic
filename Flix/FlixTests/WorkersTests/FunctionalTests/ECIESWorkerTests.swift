//
//  ECIESWorkerTests.swift
//  FlixTests
//
//  Created by Anton Romanov on 27.01.2022.
//

import XCTest
@testable import Flix

final class ECIESWorkerTests: XCTestCase {

    // MARK: - Properties
    private var eciesWorker: ECIESWorkerLogic!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()

        eciesWorker = ECIESWorker()
    }

    override func tearDown() {
        eciesWorker = nil

        super.tearDown()
    }

    // MARK: - Public Methods
    func testEncryption() {
        let msg = "Message to Anton, 27.01.2022."
        let hexOfPublicKey = "047731a78644c249dfa485ef0860bbb96023d795f9db358aef97a3604578d8b0f3fc8cb6262b60acaed063a1652c0a03553acdd595aa8ecc96a5239a44a8f42f8f"

        do {
            let encrypted = try eciesWorker.encrypt(msg: msg, hexOfPublicKey: hexOfPublicKey)
            XCTAssertTrue(encrypted.prefix(2) == "04", "Encrypted doesn't have 04 prefix.")
            XCTAssertTrue(encrypted.count == 284, "Encrypted doesn't have correct length for this msg and pubKey")
        } catch {
            print("ECIES encryption error: \(error.localizedDescription)")
        }
    }

    func testDecryption() {
        let encryptedMsg = "0424d810cfd6fdf1be7b54d542fc3343f5a55e3119a64adb17b197f2ee08de1f4227c21dd45b47adf71dae2a940dda4479f6bdfe97642771a9dd29f58768e2b34b9bae3e6a948e6a9b9881275cf7e0e5b2aa549396cda373e1826af8c707fb61600e099213b98a9397aa50bd7bf2a8ca2672d6223a8e7601e2a167e0eb366a9717c3483f50da68f637ab8ab5b99123ad254022e1afc5bdb7a2"
        let hexOfPrivateKey = "8d42cb5736502ade9c27d5d140866201b13906079253dcde711ac84849054922"

        do {
            let decrypted = try eciesWorker.decrypt(encryptedMsg: encryptedMsg, hexOfPrivateKey: hexOfPrivateKey)
            XCTAssertTrue(decrypted == "Message to Anton to decrypt, 27.01.2022.", "Decrypted msg is incorrect.")
        } catch {
            print("ECIES decryption error: \(error.localizedDescription)")
        }
    }
}
