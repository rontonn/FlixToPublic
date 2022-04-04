//
//  CurvePoint.swift
//  Flix
//
//  Created by Anton Romanov on 15.01.2022.
//

import BigInt

class CurvePoint {
    // MARK: - Properties
    static let base = CurvePoint(CurveEC256k1.gx, CurveEC256k1.gy)
    static let zero = CurvePoint(BInt(0), BInt(0))
    
    let x: BInt
    let y: BInt

    // MARK: - Lifecycle
    init(_ x: BInt, _ y: BInt) {
        self.x = x
        self.y = y
    }
}

// MARK: - Static Public methods
extension CurvePoint {
    static func create(from bytes: Bytes) throws -> CurvePoint {
        guard let header = bytes[safe: 0] else {
            throw PriviError(title: "CurvePoint.create", msg: "Bytes are empty.")
        }
        var point: CurvePoint?
        if bytes.count == 32 || bytes.count == 33 && (header == Byte(0x02) || header == Byte(0x03)) {
            point = try fromCompressedhex(bytes)

        } else if bytes.count == 65 || header == Byte(0x04) {
            point = try fromUncompressedhex(bytes)
        }
        if let point = point {
            return point
        } else {
            throw PriviError(title: "CurvePoint.create", msg: "Bytes have invalid format.")
        }
    }

    static func bytesToNumber(_ bytes: Bytes) throws -> BInt {
        let hex = bytes.toHexString()
        if let bInt = BInt(hex, radix: 16) {
            return bInt
        } else {
            throw PriviError(title: "CurvePoint.bytesToNumber", msg: "Failed to create BigInt from hex.")
        }
    }

    static func mod(_ a: BInt, _ b: BInt = CurveEC256k1.p) -> BInt {
        let result = a % b
        return result >= 0 ? result : b + result
    }
}
// MARK: - Static Private methods
extension CurvePoint {
    private static func fromCompressedhex(_ bytes: Bytes) throws -> CurvePoint {
        let isShort = bytes.count == 32
        let bytesToProceed = isShort ? bytes : bytes[safe: 1...]

        guard let bytesToProceed = bytesToProceed else {
            throw PriviError(title: "CurvePoint.fromCompressedhex", msg: "Failed to use bytes.")
        }
        let x = try bytesToNumber(bytesToProceed)
        let y2 = weistrass(x)// y² = x³ + ax + b
        var y = sqrtMod(y2) // y = y² ^ (p+1)/4
        let isYOdd = y.isOdd

        if isShort {
            // Schnorr
            if isYOdd {
                y = mod(-y)
            }
        } else {
            // ECDSA
            let isFirstByteOdd = bytes[0] & 1 == 1
            if isFirstByteOdd != isYOdd {
                y = mod(-y)
            }
        }
        return CurvePoint(x, y)
    }
    
    private static func fromUncompressedhex(_ bytes: Bytes) throws -> CurvePoint {
        guard let bytexForX = bytes[safe: 1...32],
              let bytesForY = bytes[safe: 33...] else {
            throw PriviError(title: "CurvePoint.fromUncompressedhex", msg: "Failed to retrieve X and Y bytes.")
        }
        let x = try bytesToNumber(bytexForX)
        let y = try bytesToNumber(bytesForY)
        return CurvePoint(x, y)
    }

    private static func weistrass(_ x: BInt) -> BInt {
        let eq: BInt = x * x * x + CurveEC256k1.a * x + CurveEC256k1.b
        return mod(eq)
    }

    private static func sqrtMod(_ x: BInt) -> BInt {
        let p = CurveEC256k1.p
        let _6n = BInt.SIX
        let _11n = BInt(11)
        let _22n = BInt(22)
        let _23n = BInt(23)
        let _44n = BInt(44)
        let _88n = BInt(88)

        let b2 = (x * x * x) % p
        let b3 = (b2 * b2 * x) % p
        let b6 = (pow2(b3, BInt.THREE) * b3) % p
        let b9 = (pow2(b6, BInt.THREE) * b3) % p
        let b11 = (pow2(b9, BInt.TWO) * b2) % p
        let b22 = (pow2(b11, _11n) * b11) % p
        let b44 = (pow2(b22, _22n) * b22) % p
        let b88 = (pow2(b44, _44n) * b44) % p
        let b176 = (pow2(b88, _88n) * b88) % p
        let b220 = (pow2(b176, _44n) * b44) % p
        let b223 = (pow2(b220, BInt.THREE) * b3) % p
        let t1 = (pow2(b223, _23n) * b22) % p
        let t2 = (pow2(t1, _6n) * b2) % p
        return pow2(t2, BInt.TWO)
    }
    
    private static func pow2(_ x: BInt, _ power: BInt) -> BInt {
        let p = CurveEC256k1.p
        var res = x
        var counter = power
        while counter > BInt.ZERO {
            res *= res
            res %= p
            counter -= 1
        }
        return res
    }
}

// MARK: - Instance Public methods
extension CurvePoint {
    func multiply(_ scalar: BInt) throws -> CurvePoint {
        let cPoint = CurvePoint(x, y)
        let rawJacobianPoint = JacobianPoint(cPoint)
        let jacobianPoint = try rawJacobianPoint.multiply(scalar: scalar,
                                                          affinePoint: CurvePoint(x, y))
        let curvePoint = try jacobianPoint.toAffine()
        return curvePoint
    }

    func toRawBytes(_ isCompressed: Bool = false) throws -> Bytes {
        let hex = try toHex(isCompressed)
        return try hexToBytes(hex)
    }
    
    func toHex(_ isCompressed: Bool = false) throws -> String {
        let x = try pad64(x)
        if isCompressed {
            return x
        } else {
            let y = try pad64(y)
            return "04" + x + y
        }
    }
}

// MARK: - Instance Private methods
extension CurvePoint {
    private func hexToBytes(_ hex: String) throws -> Bytes {
        guard hex.count % 2 == 0 else {
            throw PriviError(title: "CurvePoint.hexToBytes", msg: "Hex has incorrect length.")
        }
        var tempArray = Array<UInt8>(repeating: 0, count: hex.count / 2)
        for i in 0..<tempArray.count {
            let j = i * 2
            if let hexByte = Array(hex)[safe: j...j+1] {
                let hexByteString = String(hexByte)
                if let byte = UInt8(hexByteString, radix: 16) {
                    tempArray[i] = byte
                }
            }
        }
        return tempArray
    }

    private func pad64(_ num: BInt) throws -> String {
        if (num > BInt(2) ** 256) {
            throw PriviError(title: "CurvePoint.pad64", msg: "Failed to get pad64 from BigInt.")
        }
        return num.asString(radix: 16)
    }
}
