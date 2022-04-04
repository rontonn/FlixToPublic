//
//  RemoteRequestExecuter.swift
//  Flix
//
//  Created by Anton Romanov on 03.12.2021.
//

import Foundation

enum RemoteRequestExecuter {
    typealias RequestResult = (data: Data, response: URLResponse)

    // MARK: - Public methods
    static func execute(_ request: URLRequest) async throws -> RequestResult {

        let requestResult = try await URLSession.shared.data(for: request)
        return requestResult
    }
}
