//
//  XCTestCase+Extensions.swift
//  FlixTests
//
//  Created by Anton Romanov on 26.11.2021.
//

import Foundation
import XCTest

extension XCTestCase {
    func randomUUIDs() -> [UUID] {
        var uuids = [UUID]()
        for _ in 1...10 {
            uuids.append(UUID())
        }
        return uuids
    }
}
