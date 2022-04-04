//
//  RequestDataModels.swift
//  Flix
//
//  Created by Anton Romanov on 03.12.2021.
//

import Foundation

// MARK: - RequestMethod
enum RequestMethod: String {
    case post = "POST"
    case get = "GET"
    case delete = "DELETE"
    case patch = "PATCH"
}

// MARK: - RequestUrlType
enum RequestUrlType: String {
    case absolute
    case relative
}

// MARK: - RequestFormerData
struct RequestFormerData {
    // MARK: - Proeprties
    let path: String
    let method: RequestMethod
    let parameters: Data?
    let headers: [String: String]?
    let timeoutInterval: TimeInterval
    let urlType: RequestUrlType

    // MARK: - Lifecycle
    init(path: String,
         method: RequestMethod,
         parameters: Data? = nil,
         headers: [String: String]? = nil,
         timeoutInterval: TimeInterval = 30.0,
         urlType: RequestUrlType = .relative) {
        self.path = path
        self.method = method
        self.parameters = parameters
        self.headers = headers
        self.timeoutInterval = timeoutInterval
        self.urlType = urlType
    }
}
