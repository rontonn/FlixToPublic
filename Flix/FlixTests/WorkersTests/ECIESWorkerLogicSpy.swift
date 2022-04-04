//
//  ECIESWorkerLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 16.01.2022.
//

@testable import Flix

final class ECIESWorkerLogicSpy {
    // MARK: - Public Properties
    private (set) var isCalledEncrypt = false
    private (set) var isCalledDecrypt = false
}

extension ECIESWorkerLogicSpy: ECIESWorkerLogic {
    func encrypt(msg: String, hexOfPublicKey: String) throws -> String {
        isCalledEncrypt = true
        return ""
    }

    func decrypt(encryptedMsg: String, hexOfPrivateKey: String) throws -> String {
        isCalledDecrypt = true
        return ""
    }
}
