//
//  WBAesWorkerLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 27.01.2022.
//

@testable import Flix

final class WBAesWorkerLogicSpy {
    // MARK: - Public Properties
    private (set) var isCalledDecrypt = false
    private (set) var isCalledBytesFrom = false
}

extension WBAesWorkerLogicSpy: WBAesWorkerLogic {
    func decrypt(_ cipherText: String) throws -> String {
        isCalledDecrypt = true
        return ""
    }
    
    func bytes(from wbaesMsg: String) throws -> [UInt8] {
        isCalledBytesFrom = true
        return []
    }
}
