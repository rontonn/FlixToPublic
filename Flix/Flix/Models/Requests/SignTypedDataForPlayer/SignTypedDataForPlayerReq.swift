//
//  SignTypedDataForPlayerReq.swift
//  Flix
//
//  Created by Anton Romanov on 18.01.2022.
//

import Foundation

struct SignTypedDataForPlayerReq {
    static let method = "eth_signTypedData_v3"

    // MARK: - Properties
    let dataString: String

    // MARK: - Lifecycle
    init?(address: String, publicKey: String) {
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
                "name": "Media Encryption Public Key",
                "type": "string"
            }
        ]
    },
    "primaryType": "Mail",
    "domain": {
        "name": "Myx",
        "version": "1.0.0-beta"
    },
    "message": {
        "Address": "\(address)",
        "Media Encryption Public Key": "\(publicKey)"
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
