//
//  SignTypedDataRsp.swift
//  Flix
//
//  Created by Anton Romanov on 06.12.2021.
//

import Foundation

struct SignTypedDataRsp: Codable {
    // MARK: - Properties
    let id: String
    let jsonrpc: String
    let result: String
}
