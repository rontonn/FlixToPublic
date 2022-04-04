//
//  TvChannelItem.swift
//  Flix
//
//  Created by Anton Romanov on 01.11.2021.
//

import UIKit

struct TvChannelItem {
    // MARK: - Properties
    let category: Category
    let id = UUID()
}

// MARK: - Hashable
extension TvChannelItem: Hashable {
    static func ==(lhs: TvChannelItem, rhs: TvChannelItem) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

extension TvChannelItem {
    enum Category {
        case flixLive
        case daily
        case crypto

        var title: NSMutableAttributedString? {
            let info = NSMutableAttributedString(string: "")
            
            switch self {
            case .flixLive:
                let firstAttr: [NSAttributedString.Key: Any] = [.font: UIFont.agrandir(font: .grandHeavy, ofSize: 36),
                                                                .foregroundColor: UIColor.white]
                let firstString = NSMutableAttributedString(string: "FLIX", attributes: firstAttr)

                let secondAttr: [NSAttributedString.Key: Any] = [.font: UIFont.agrandir(font: .regular, ofSize: 36),
                                                                 .foregroundColor: UIColor.white]
                let secondString = NSMutableAttributedString(string: "\nLIVE", attributes: secondAttr)

                let thirdAttr: [NSAttributedString.Key: Any] = [.font: UIFont.agrandir(font: .grandHeavy, ofSize: 36),
                                                                 .foregroundColor: UIColor.white]
                let thirString = NSMutableAttributedString(string: " TV", attributes: thirdAttr)
                
                info.append(firstString)
                info.append(secondString)
                info.append(thirString)

            case .daily:
                let firstAttr: [NSAttributedString.Key: Any] = [.font: UIFont.agrandir(font: .grandHeavy, ofSize: 36),
                                                                .foregroundColor: UIColor.white]
                let firstString = NSMutableAttributedString(string: "DAILY", attributes: firstAttr)

                let secondAttr: [NSAttributedString.Key: Any] = [.font: UIFont.agrandir(font: .regular, ofSize: 36),
                                                                 .foregroundColor: UIColor.white]
                let secondString = NSMutableAttributedString(string: "\nNEWS", attributes: secondAttr)
                
                info.append(firstString)
                info.append(secondString)

            case .crypto:
                let firstAttr: [NSAttributedString.Key: Any] = [.font: UIFont.agrandir(font: .grandHeavy, ofSize: 36),
                                                                .foregroundColor: UIColor.white]
                let firstString = NSMutableAttributedString(string: "CRYPTO", attributes: firstAttr)

                let secondAttr: [NSAttributedString.Key: Any] = [.font: UIFont.agrandir(font: .regular, ofSize: 36),
                                                                 .foregroundColor: UIColor.white]
                let secondString = NSMutableAttributedString(string: "\nUPDATE", attributes: secondAttr)
                
                info.append(firstString)
                info.append(secondString)
            }
            return info.length == 0 ? nil : info
        }
    }
}
