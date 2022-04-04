//
//  SignTypedDataReq.swift
//  Flix
//
//  Created by Anton Romanov on 03.12.2021.
//

import Foundation

struct SignTypedDataReq {
    static let method = "eth_signTypedData"

    // MARK: - Properties
    let dataString: String

    // MARK: - Lifecycle
    init?(address: String, nonce: String) {
        let rawString = """
{
    "types": {
        "EIP712Domain": [{
                "name": "name",
                "type": "string"
            },
            {
                "name": "version",
                "type": "string"
            }
        ],
        "Mail": [{
                "name": "Address",
                "type": "address"
            },
            {
                "name": "Nonce",
                "type": "string"
            }
        ]
    },
    "primaryType": "Mail",
    "domain": {
        "name": "Flix",
        "version": "1.0.0-beta"
    },
    "message": {
        "Address": "\(address)",
        "Nonce": "\(nonce)"
    }
}
"""
        let encodedData = Data(rawString.utf8)
        if let dataString = String(data: encodedData, encoding: .utf8) {
            self.dataString = dataString
        } else {
            return nil
        }
    }
}
