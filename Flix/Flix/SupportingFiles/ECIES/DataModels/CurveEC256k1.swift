//
//  CurveEC256k1.swift
//  Flix
//
//  Created by Anton Romanov on 15.01.2022.
//

import BigInt

class CurveEC256k1 {
    // MARK: - Properties
    static let name = "secp256k1"
    static let p = BInt("fffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f", radix: 16)!
    static let a = BInt("0000000000000000000000000000000000000000000000000000000000000000", radix: 16)!
    static let b = BInt("0000000000000000000000000000000000000000000000000000000000000007", radix: 16)!
    static let gx = BInt("79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798", radix: 16)!
    static let gy = BInt("483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8", radix: 16)!
    static let order = BInt("fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141", radix: 16)!
    static let cofactor = 1
}
