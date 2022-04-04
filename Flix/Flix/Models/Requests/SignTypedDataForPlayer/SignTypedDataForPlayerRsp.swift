//
//  SignTypedDataForPlayerRsp.swift
//  Flix
//
//  Created by Anton Romanov on 18.01.2022.
//

import Foundation

struct SignTypedDataForPlayerRsp: Codable {
    // MARK: - Properties
    let id: String
    let jsonrpc: String
    let result: String
}
