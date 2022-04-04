//
//  UIFont+Extensions.swift
//  FlixAR
//
//  Created by Anton Romanov on 13.10.2021.
//

import UIKit

extension UIFont {
    // MARK: - Jakarta
    enum PlusJakarta: String {
        case display = "Display"
        case text = "Text"

        var fontName: String {
            return "PlusJakarta" + rawValue
        }

        enum FontWeight: String {
            case bold = "Bold"
            case boldItalic = "BoldItalic"
            case italic = "Italic"
            case light = "Light"
            case lightItalic = "LightItalic"
            case medium = "Medium"
            case mediumItalic = "MediumItalic"
            case regular = "Regular"
            case ultraWide = "UltraWide"
        }
    }

    class func jakarta(font: PlusJakarta,
                       ofSize: CGFloat,
                       weight: PlusJakarta.FontWeight) -> UIFont {
        let fontName = font.fontName + "-" + weight.rawValue
        let font = UIFont(name: fontName, size: ofSize)
        return font ?? UIFont.systemFont(ofSize: ofSize)
    }
    //
    // MARK: - Agrandir
    enum Agrandir: String {
        case grand = "Grand"
        case grandHeavy = "GrandHeavy"
        case grandItalic = "GrandItalic"
        case grandLight = "GrandLight"
        case italic = "Italic"
        case narrow = "Narrow"
        case narrowBlack = "NarrowBlack"
        case regular = "Regular"
        case textBold = "TextBold"
        case thinItalic = "ThinItalic"
        case tight = "Tight"
        case tightBlack = "TightBlack"
        case tightThin = "TightThin"
        case wideBlackItalic = "WideBlackItalic"
        case wideLight = "WideLight"

        var fontName: String {
            return "Agrandir" + "-" + rawValue
        }
    }

    class func agrandir(font: Agrandir,
                        ofSize: CGFloat) -> UIFont {
        let fontName = font.fontName
        let font = UIFont(name: fontName, size: ofSize)
        return font ?? UIFont.systemFont(ofSize: ofSize)
    }
    //
}
