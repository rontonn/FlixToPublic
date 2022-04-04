//
//  GradientOwner.swift
//  Flix
//
//  Created by Anton Romanov on 28.10.2021.
//

import UIKit

enum GradientOwner {
    case textCell
    case musicCell
    case profileCell
    case trendingChannel(item: TvChannelItem.Category)

    // MARK: - Properties
    var locations: [NSNumber] {
        switch self {
        case .textCell:
            return [0.01, 1]
        case .musicCell:
            return [0, 0.93]
        case .profileCell:
            return [0, 1]
        case .trendingChannel(let ch):
            switch ch {
            case .flixLive, .daily, .crypto:
                return [0, 1]
            }
        }
    }
    var colors: [CGColor] {
        switch self {
        case .textCell:
            return [UIColor.creamyPeach.cgColor,
                    UIColor.redPeach.cgColor]
        case .musicCell:
            return [UIColor.orange878.withAlphaComponent(0.33).cgColor,
                    UIColor.orange878.withAlphaComponent(0).cgColor]
        case .profileCell:
            return [UIColor.white.withAlphaComponent(0.13).cgColor,
                    UIColor.black.withAlphaComponent(0).cgColor]
        case .trendingChannel(let ch):
            switch ch {
            case .flixLive:
                return [UIColor.orangeE0E.cgColor,
                        UIColor.orange800B.cgColor]
            case .daily:
                return [UIColor.blue6FF.cgColor,
                        UIColor.blueBFF.cgColor]
            case .crypto:
                return [UIColor.greenCE2D.cgColor,
                        UIColor.green744D.cgColor]
            }
        }
    }
    var backgroundColor: CGColor {
        switch self {
        case .textCell:
            return UIColor.black1.cgColor
        case .musicCell:
            return UIColor.clear.cgColor
        case .profileCell:
            return UIColor.grey130.cgColor
        case .trendingChannel(let ch):
            switch ch {
            case .flixLive, .daily, .crypto:
                return UIColor.clear.cgColor
            }
        }
    }
    var startPoint: CGPoint {
        switch self {
        case .textCell:
            return CGPoint(x: 0.25, y: 0.5)
        case .musicCell:
            return CGPoint(x: 0.25, y: 0.5)
        case .profileCell:
            return CGPoint(x: 0.25, y: 0.5)
        case .trendingChannel(let ch):
            switch ch {
            case .flixLive, .daily, .crypto:
                return CGPoint(x: 0.25, y: 0.5)
            }
        }
    }
    var endPoint: CGPoint {
        switch self {
        case .textCell:
            return CGPoint(x: 0.75, y: 0.5)
        case .musicCell:
            return CGPoint(x: 0.75, y: 0.5)
        case .profileCell:
            return CGPoint(x: 0.75, y: 0.5)
        case .trendingChannel(let ch):
            switch ch {
            case .flixLive, .daily, .crypto:
                return CGPoint(x: 0.75, y: 0.5)
            }
        }
    }
    var cornerRadius: CGFloat? {
        switch self {
        case .textCell:
            return 42
        case .musicCell:
            return 32
        case .profileCell:
            return 37
        case .trendingChannel(let ch):
            switch ch {
            case .flixLive, .daily, .crypto:
                return 20
            }
        }
    }
    var transform: CATransform3D {
        switch self {
        case .textCell:
            return CATransform3DMakeAffineTransform(CGAffineTransform(a: 0.99, b: 0, c: 0, d: 5.17, tx: 0, ty: -2.58))
        case .musicCell:
            return CATransform3DMakeAffineTransform(CGAffineTransform(a: 0, b: 1, c: -1, d: 0, tx: 1, ty: 0))
        case .profileCell:
            return CATransform3DMakeAffineTransform(CGAffineTransform(a: 0, b: 1, c: -1, d: 0, tx: 1, ty: 0))
        case .trendingChannel(let ch):
            switch ch {
            case .flixLive, .daily, .crypto:
                return CATransform3DMakeAffineTransform(CGAffineTransform(a: -0.27, b: 1.45, c: -1.45, d: -1.7, tx: 1.22, ty: 0.85))
            }
        }
    }
    var borderWidth: CGFloat? {
        switch self {
        case .textCell:
            return 1
        default:
            return nil
        }
    }
    var borderColor: UIColor? {
        switch self {
        case .textCell:
            return .grey23
        default:
            return nil
        }
    }
    func adjustedBounds(_ bounds: CGRect) -> CGRect {
        switch self {
        case .textCell:
            return bounds.insetBy(dx: -0.5 * bounds.size.width, dy: -0.5 * bounds.size.height)
        case .musicCell:
            return bounds.insetBy(dx: -0.5 * bounds.size.width, dy: -0.5 * bounds.size.height)
        case .profileCell:
            return bounds.insetBy(dx: -0.5 * bounds.size.width, dy: -0.5 * bounds.size.height)
        case .trendingChannel(let ch):
            switch ch {
            case .flixLive, .daily, .crypto:
                return bounds.insetBy(dx: -0.5 * bounds.size.width, dy: -0.5 * bounds.size.height)
            }
        }
    }
}
