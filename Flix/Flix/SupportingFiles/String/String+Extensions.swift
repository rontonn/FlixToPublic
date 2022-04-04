//
//  String+Extensions.swift
//  Flix
//
//  Created by Anton Romanov on 14.10.2021.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: "LocalizedStrings", value: self, comment: "")
    }
}
