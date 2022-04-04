//
//  JacobianPoint.swift
//  Flix
//
//  Created by Anton Romanov on 15.01.2022.
//

import BigInt

class JacobianPoint {
    // MARK: - Properties
    static let base = JacobianPoint(CurveEC256k1.gx, CurveEC256k1.gy, BInt.ONE)
    static let zero = JacobianPoint(BInt.ZERO, BInt.ONE, BInt.ZERO)
    private let POW_2_128 = BInt.TWO ** 128
    private let optimizationBeta = BInt("7ae96a2b657c07106e64479eac3434e99cf0497512f58995c1396c28719501ee", radix: 16)

    let x: BInt
    let y: BInt
    let z: BInt

    // MARK: - Lifecycle
    init(_ x: BInt, _ y: BInt, _ z: BInt) {
        self.x = x
        self.y = y
        self.z = z
    }

    convenience init(_ p: CurvePoint) {
        self.init(p.x, p.y, BInt.ONE)
    }
}

// MARK: - Public methods
extension JacobianPoint {
    // Constant time multiplication.
    func multiply(scalar: BInt, affinePoint: CurvePoint?) throws -> JacobianPoint {
        guard isWithinCurveOrder(scalar) else {
            throw PriviError(title: "JacobianPoint.multiply", msg: "Scalar doesn't belong to the curve.")
        }

        let splitedScalar = try splitScalarEndo(scalar)
        let pkf1 = try wNAF(splitedScalar.k1, affinePoint)
        let pkf2 = try wNAF(splitedScalar.k2, affinePoint)
        
        var k1p = pkf1.p
        let f1p = pkf1.f
        
        var k2p = pkf2.p
        let f2p = pkf2.f
        
        if splitedScalar.k1neg {
            k1p = k1p.negate()
        }
        if splitedScalar.k2neg {
            k2p = k2p.negate()
        }
        if let optimizationBeta = optimizationBeta {
            k2p = JacobianPoint(CurvePoint.mod(k2p.x * optimizationBeta), k2p.y, k2p.z)
        }
        let jPoint = k1p.add(k2p)
        let fakePoint = f1p.add(f2p)

        let resultingPoint = try normalizeZ([jPoint, fakePoint])
        if let resultingPoint = resultingPoint[safe: 0] {
            return resultingPoint
        } else {
            throw PriviError(title: "JacobianPoint.multiply", msg: "No Jacobian points wre found.")
        }
    }

    // Converts Jacobian point to affine (x, y) coordinates.
    // Can accept precomputed Z^-1 - for example, from invertBatch.
    // (x, y, z) ∋ (x=x/z², y=y/z³)
    func toAffine(_ invertedZ: BInt? = nil) throws -> CurvePoint {
        let invZ: BInt
        if let invertedZ = invertedZ {
            invZ = invertedZ
        } else {
            let invertedZ = try invert(z)
            invZ = invertedZ
        }
        let invZ2 = invZ ** 2
        let x = CurvePoint.mod(x * invZ2)
        let y = CurvePoint.mod(y * invZ2 * invZ)
        return CurvePoint(x, y)
    }
}

// MARK: - Private methods
extension JacobianPoint {
    private func isWithinCurveOrder(_ num: BInt) -> Bool {
        return BInt.ZERO < num && num < CurveEC256k1.order
    }

    private func splitScalarEndo(_ k: BInt) throws -> SplitedScalar {
        let n = CurveEC256k1.order
        let a1 = BInt("3086d221a7d46bcde86c90e49284eb15", radix: 16)!
        let b1 = -BInt.ONE * BInt("e4437ed6010e88286f547fa90abfe4c3", radix: 16)!
        let a2 = BInt("114ca50f7a8e2f3f657c1108d9d44cfd8", radix: 16)!
        let b2 = a1
        let c1 = divNearest(b2 * k, n)
        let c2 = divNearest(-b1 * k, n)
        
        var k1 = CurvePoint.mod(k - c1 * a1 - c2 * a2, n)
        var k2 = CurvePoint.mod(-c1 * b1 - c2 * b2, n)
        
        let k1neg = k1 > POW_2_128
        let k2neg = k2 > POW_2_128
        
        if k1neg {
            k1 = n - k1
        }
        if k2neg {
            k2 = n - k2
        }
        if (k1 > POW_2_128 || k2 > POW_2_128) {
            throw PriviError(title: "JacobianPoint.splitScalarEndo", msg: "Failure in K1 or K2 size estimation.")
        }
        return SplitedScalar(k1neg: k1neg, k1: k1, k2neg: k2neg, k2: k2)
    }

    private func divNearest(_ a: BInt, _ b: BInt) -> BInt {
        return (a + b / BInt.TWO) / b
    }

    // Implements w-ary non-adjacent form for calculating ec multiplication
    private func wNAF(_ number: BInt, _ affinePoint: CurvePoint?) throws -> (p: JacobianPoint, f: JacobianPoint) {
        var n = number
        var aPoint = affinePoint
        if aPoint == nil, equals(JacobianPoint.base) {
            aPoint = CurvePoint.base
        }
        let w = affinePoint != nil ? 8 : 1
        if (256 % w) != 0 {
            throw PriviError(title: "JacobianPoint.wNAF", msg: "W must be a multiple of 256.")
        }
        var precomputes = precomputeWindow(w)
        
        if affinePoint != nil, w != 1 {
            precomputes = try normalizeZ(precomputes)
        }
        
        // Initialize real and fake points for const-time
        var p = JacobianPoint.zero
        var f = JacobianPoint.zero

        let windows = 128 / w + 1 // for other curves 256 / W + 1
        let windowSize = BInt(2) ** (w - 1) // W=8 128
        let mask = BInt(2) ** w - 1 // Create mask with W ones: 0b11111111 for W=8
        let maxNumber = BInt(2) ** w // W=8 256
        let shiftBy = w // W=8 8
        
        // TODO: review this more carefully
        for window in 0..<windows {
            let offset = (window * windowSize).asInt()!
            // Extract W bits.
            var wbits = n & mask

            // Shift number by W bits.
            n >>= shiftBy

            // If the bits are bigger than max size, we'll split those.
            // +224 => 256 - 32
            if (wbits > windowSize) {
                wbits -= maxNumber
                n += BInt.ONE
            }

            // Check if we're onto Zero point.
            // Add random point inside current window to f.
            if (wbits == 0) {
                // The most important part for const-time getPublicKey
                var pr = precomputes[offset]
                if (window % 2) == 0 {
                    pr = pr.negate()
                }
                f = f.add(pr)
            } else {
                let index = offset + abs(wbits.asInt()!) - 1
                var cached = precomputes[index]
                if (wbits < 0) {
                    cached = cached.negate()
                }
                p = p.add(cached)
            }
        }
        return (p, f)
    }

    private func equals(_ other: JacobianPoint) -> Bool {
        let az2 = CurvePoint.mod(z * z)
        let az3 = CurvePoint.mod(z * az2)
        let bz2 = CurvePoint.mod(other.z * other.z)
        let bz3 = CurvePoint.mod(other.z * bz2)
        return CurvePoint.mod(x * bz2) == CurvePoint.mod(az2 * other.x) && CurvePoint.mod(y * bz3) == CurvePoint.mod(az3 * other.y)
    }

    private func precomputeWindow(_ w: Int) -> [JacobianPoint] {
        let windows = 128 / w + 1 // for the curve secp256k1, for others 256 / w + 1
        var points: [JacobianPoint] = []
        var p = JacobianPoint(x, y, z)
        var base = p
        
        for _ in 0..<windows {
            base = p
            points.append(base)
            
            let poweredCounter = BInt(2) ** (w-1)
            for _ in 1..<poweredCounter.asInt()! {
                base = base.add(p)
                points.append(base)
            }
            p = base.double()
        }
        return points
    }

    // Fast algo for adding 2 Jacobian Points when curve's a=0.
    // Note: cannot be reused for other curves when a != 0.
    // http://hyperelliptic.org/EFD/g1p/auto-shortw-jacobian-0.html#addition-add-1998-cmo-2
    // Cost: 12M + 4S + 6add + 1*2.
    // Note: 2007 Bernstein-Lange (11M + 5S + 9add + 4*2) is actually *slower*. No idea why.
    private func add(_ other: JacobianPoint) -> JacobianPoint {
        let x1 = x
        let y1 = y
        let z1 = z
        let x2 = other.x
        let y2 = other.y
        let z2 = other.z
        if (x2 == BInt.ZERO || y2 == BInt.ZERO) {
            return JacobianPoint(x, y, z)
        }
        if (x1 == BInt.ZERO || y1 == BInt.ZERO) {
            return other
        }
        let z1z1 = CurvePoint.mod(z1 ** 2)
        let z2z2 = CurvePoint.mod(z2 ** 2)
        let u1 = CurvePoint.mod(x1 * z2z2)
        let u2 = CurvePoint.mod(x2 * z1z1)
        let s1 = CurvePoint.mod(y1 * z2 * z2z2)
        let s2 = CurvePoint.mod(CurvePoint.mod(y2 * z1) * z1z1)
        let h = CurvePoint.mod(u2 - u1)
        let r = CurvePoint.mod(s2 - s1)
        // H = 0 meaning it's the same point.
        if (h == BInt.ZERO) {
          if (r == BInt.ZERO) {
            return double()
          } else {
            return JacobianPoint.zero;
          }
        }
        let hh = CurvePoint.mod(h ** 2)
        let hhh = CurvePoint.mod(h * hh)
        let v = CurvePoint.mod(u1 * hh)
        let x3 = CurvePoint.mod(r ** 2 - hhh - BInt.TWO * v)
        let y3 = CurvePoint.mod(r * (v - x3) - s1 * hhh)
        let z3 = CurvePoint.mod(z1 * z2 * h)
        return JacobianPoint(x3, y3, z3)
    }

    // Fast algo for doubling 2 Jacobian Points when curve's a=0.
    // Note: cannot be reused for other curves when a != 0.
    // From: http://hyperelliptic.org/EFD/g1p/auto-shortw-jacobian-0.html#doubling-dbl-2009-l
    // Cost: 2M + 5S + 6add + 3*2 + 1*3 + 1*8.
    private func double() -> JacobianPoint {
        let x1 = x
        let y1 = y
        let z1 = z
        let a = CurvePoint.mod(x1 ** 2)
        let b = CurvePoint.mod(y1 ** 2)
        let c = CurvePoint.mod(b ** 2)
        let d = CurvePoint.mod(BInt.TWO * (CurvePoint.mod(CurvePoint.mod((x1 + b) ** 2)) - a - c))
        let e = CurvePoint.mod(BInt.THREE * a)
        let f = CurvePoint.mod(e ** 2)
        let x3 = CurvePoint.mod(f - BInt.TWO * d)
        let y3 = CurvePoint.mod(e * (d - x3) - BInt.EIGHT * c)
        let z3 = CurvePoint.mod(BInt.TWO * y1 * z1)
        return JacobianPoint(x3, y3, z3)
    }

    private func normalizeZ(_ points: [JacobianPoint]) throws -> [JacobianPoint] {
        return try toAffineBatch(points).map { JacobianPoint($0) }
    }
    
    private func toAffineBatch(_ points: [JacobianPoint]) throws -> [CurvePoint] {
        let zs = points.map{ $0.z }
        let toInv = try invertBatch(zs)
        let newPoints = try points.enumerated().compactMap {
            try $0.element.toAffine(toInv[$0.offset])
        }
        return newPoints
    }

    // Takes a bunch of numbers, inverses all of them
    private func invertBatch(_ numbers: [BInt], _ n: BInt = CurveEC256k1.p) throws -> [BInt] {
        let len = numbers.count
        var nums = numbers
        var scratch = Array(repeating: BInt.ZERO, count: len)
        var acc = BInt.ONE
        for i in 0..<len {
            if (nums[i] == BInt.ZERO) {
                continue
            }
            scratch[i] = acc
            acc = CurvePoint.mod(acc * nums[i], n)
        }
        let inverted = try invert(acc, n)
        acc = inverted
        for i in (0...(len - 1)).reversed() {
            if (nums[i] == BInt.ZERO) {
                continue
            }
            let tmp = CurvePoint.mod(acc * nums[i], n)
            nums[i] = CurvePoint.mod(acc * scratch[i], n)
            acc = tmp
        }
        return nums
    }

    // Inverses number over modulo
    private func invert(_ number: BInt, _ modulo: BInt = CurveEC256k1.p) throws -> BInt {
        if (number == BInt.ZERO || modulo <= BInt.ZERO) {
            throw PriviError(title: "JacobianPoint.invert", msg: "Number is zero or modulo is below zero.")
        }
        // Eucledian GCD https://brilliant.org/wiki/extended-euclidean-algorithm/
        var a = CurvePoint.mod(number, modulo)
        var b = modulo
        // prettier-ignore
        var x = BInt.ZERO, y = BInt.ONE, u = BInt.ONE, v = BInt.ZERO
        while (a != BInt.ZERO) {
            let q = b / a
            let r = b % a
            let m = x - u * q
            let n = y - v * q
            // prettier-ignore
            b = a
            a = r
            x = u
            y = v
            u = m
            v = n
        }
        let gcd = b
        if (gcd != BInt.ONE) {
            throw PriviError(title: "JacobianPoint.invert", msg: "GCD must equal to BigInt(1).")
        }
        return CurvePoint.mod(x, modulo)
    }

    // Flips point to one corresponding to (x, -y) in Affine coordinates.
    private func negate() -> JacobianPoint {
        return JacobianPoint(x, CurvePoint.mod(-y), z)
    }
}

// MARK: - Data modelss
extension JacobianPoint {
    struct SplitedScalar {
        let k1neg: Bool
        let k1: BInt
        let k2neg: Bool
        let k2: BInt
    }
}
