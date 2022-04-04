//
//  PlayerKeyWorkerLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 27.01.2022.
//

import Foundation
@testable import Flix

final class PlayerKeyWorkerLogicSpy {
    // MARK: - Public Properties
    private (set) var isCalledGetKeyData = false
}

extension PlayerKeyWorkerLogicSpy: PlayerKeyWorkerLogic {
    func getKeyData() async throws -> Data {
        isCalledGetKeyData = true
        return Data()
    }
}
