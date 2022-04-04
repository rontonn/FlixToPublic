//
//  PriviError.swift
//  Flix
//
//  Created by Anton Romanov on 29.10.2021.
//

import Foundation
import UIKit

final class PriviError: Error {
    // MARK: - Properties
    private var title: String
    private var msg: String?

    let actions: [PriviErrorAction]
    let image: UIImage?

    // MARK: - Lifecycle
    init(title: String,
         msg: String? = nil,
         actions: [PriviErrorAction] = [],
         image: UIImage? = UIImage(named: "warningIcon")) {
        self.title = title
        self.msg = msg
        self.actions = actions
        self.image = image
    }

    convenience init(_ type: Common) {
        self.init(title: type.error.title,
                  msg: type.error.msg,
                  actions: type.error.actions,
                  image: type.error.image)
    }
}

// MARK: - CustomStringConvertible
extension PriviError: CustomStringConvertible {
    var description: String {
        var d = title
        if let msg = msg {
            let withTitle = d + "\n" + msg
            d = d.isEmpty ? msg : withTitle
        }
        if d.isEmpty {
            d = "No error description is provided."
        }
        return d
    }
}

// MARK: - LocalizedError
extension PriviError: LocalizedError {
    var errorDescription: String? {
        return description.localized
    }
}

extension PriviError {
    enum Common {
        case existingRequest

        var error: PriviError {
            switch self {
            case .existingRequest:
                return PriviError(title: "URLRequestWorker.addDataTask.", msg: "URL Request already exists.")
            }
        }
    }
}
