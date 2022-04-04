//
//  URLRequestWorker.swift
//  Flix
//
//  Created by Anton Romanov on 31.01.2022.
//

import Foundation

actor URLRequestWorker {
    // MARK: - Properties
    static let shared = URLRequestWorker()
    private var requests: [String: URLRequest]

    // MARK: - Lifecycle
    private init() {
        requests = [:]
    }
}

// MARK: - Public methods
extension URLRequestWorker {
    func addRequest(_ id: String, _ request: URLRequest) throws {
        guard requests[id] == nil else {
            throw PriviError.Common.existingRequest.error
        }
        requests[id] = request
    }

    func removeRequest(_ id: String) {
        requests[id] = nil
    }
}
