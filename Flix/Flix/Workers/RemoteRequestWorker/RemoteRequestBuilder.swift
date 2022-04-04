//
//  RemoteRequestBuilder.swift
//  Flix
//
//  Created by Anton Romanov on 03.12.2021.
//

import Foundation

struct RemoteRequestBuilder {
    // MARK: - Properties
    private var baseURL: String
    private let requestFormerData: RequestFormerData

    // MARK: - Lifecycle
    init(baseURL: String,
         requestFormerData: RequestFormerData) {
        self.baseURL = baseURL
        self.requestFormerData = requestFormerData
    }

    // MARK: - Public methods
    func build() -> URLRequest? {
        guard let url = getURL() else {
            return nil
        }
        let request = getRequest(for: url)
        return request
    }
}

// MARK: - Private methods
private extension RemoteRequestBuilder {
    func getURL() -> URL? {
        switch requestFormerData.urlType {
        case .absolute:
            return URL(string: requestFormerData.path)
        case .relative:
            return URL(string: "\(baseURL)\(requestFormerData.path)")
        }
    }

    func getRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url,
                                 cachePolicy: .reloadIgnoringCacheData,
                                 timeoutInterval: requestFormerData.timeoutInterval)

        request.httpMethod = requestFormerData.method.rawValue
        applyHeadersTo(request: &request)
        applyParametersTo(request: &request)
        return request
    }

    func applyHeadersTo(request: inout URLRequest) {
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        request.allHTTPHeaderFields = requestFormerData.headers
    }

    func applyParametersTo(request: inout URLRequest) {
        switch requestFormerData.method {
        case .post, .patch, .delete:
            request.httpBody = requestFormerData.parameters
        case .get:
            break
        }
    }
}
