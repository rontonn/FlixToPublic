//
//  Encodable.swift
//  Flix
//
//  Created by Anton Romanov on 03.12.2021.
//

import Foundation

// MARK: - Encodable
extension Encodable {
    func toData() -> Data? {
        do {
            let d = try JSONEncoder().encode(self)
            return d
        } catch {
            print("Encodable: 'toData()' failed to encode data.")
            return nil
        }
    }
}
