//
//  RemoteRequestWorker.swift
//  Flix
//
//  Created by Anton Romanov on 03.12.2021.
//

import Foundation

protocol RemoteRequestWorkerDataProvider {
    var baseURL: String { get }
    var formerData: RequestFormerData { get }
}

extension RemoteRequestWorkerDataProvider {
    var baseURL: String {
        return "https://priv-iweb-backend-x68uu.ondigitalocean.app"//"https://backend-dev.privi.store/backend"
    }
}

struct RemoteRequestWorker {
    // MARK: - Properties
    private let builder: RemoteRequestBuilder

    // MARK: - Lifecycle
    init(dataProvider: RemoteRequestWorkerDataProvider) {
        self.builder = RemoteRequestBuilder(baseURL: dataProvider.baseURL,
                                            requestFormerData: dataProvider.formerData)
    }

    // MARK: - Public methods
    func performRequest<T: Decodable>(_ taskID: String, enableLogs: Bool = true) async throws -> T {
        let rawData = try await performRequestWithRawResult(taskID, enableLogs: enableLogs)

        if let parsedResult = RemoteRequestParser<T>().parseFrom(rawData) {
            return parsedResult
        } else {
            throw PriviError(title: "RemoteRequestWorker.performRequest.", msg: "Failed parse data to \(T.self) type.")
        }
    }

    func performRequestWithRawResult(_ taskID: String, enableLogs: Bool = true) async throws -> Data {
        guard let request = builder.build() else {
            throw PriviError(title: "RemoteRequestWorker.performRequestWithRawResult.", msg: "Failed to build network request.")
        }

        try await URLRequestWorker.shared.addRequest(taskID, request)

        logRequest(request, enableLogs)
        let rsp = try await RemoteRequestExecuter.execute(request)
        logResponse(rsp, enableLogs)

        await URLRequestWorker.shared.removeRequest(taskID)

        if let response = rsp.response as? HTTPURLResponse, response.statusCode >= 400 {
            let decodedResponse = String(data: rsp.data, encoding: .utf8)?.removingPercentEncoding
            throw PriviError(title: "RemoteRequestWorker.performRequestWithRawResult.", msg: "Response code: \(response.statusCode). \(decodedResponse ?? "").")

        } else {
            return rsp.data
        }
    }
}

// MARK: - Private methods
private extension RemoteRequestWorker {
    func logRequest(_ request: URLRequest, _ enableLogs: Bool) {
        guard enableLogs else {
            return
        }
        let requestURL = request.url?.absoluteString
        var logString = "[URL: \(requestURL ?? "None")]"

        if let headers = request.allHTTPHeaderFields {
            logString.append("\n - >   REQUEST HEADERS:")

            for (key, value) in headers {
                logString.append("\n         \(key) = \(value)")
            }
        }
        if let requestBody = request.httpBody {
            if let stringFromBody = String(data: requestBody, encoding: .utf8)?.removingPercentEncoding {
                let formattedString = stringFromBody
                    .replacingOccurrences(of: "&", with: ";\r    ")
                    .replacingOccurrences(of: "=", with: " = ")

                logString.append("\n - >   REQUEST BODY" + "\n{\r    \(formattedString)\r}")
            }
        }
        print(logString)
    }

    func logResponse(_ rsp: RemoteRequestExecuter.RequestResult, _ enableLogs: Bool) {
        guard enableLogs else {
            return
        }
        if let response = rsp.response as? HTTPURLResponse {
            print("\n - >   STATUS CODE: \(response.statusCode)")
        }
        var responseString = "Can't parse response data"

        if let json = try? JSONSerialization.jsonObject(with: rsp.data, options: [.allowFragments]) as? [String: Any],
            let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
            let string = String(data: data, encoding: .utf8) {
            responseString = string
        } else if let decoded = String(data: rsp.data, encoding: .utf8)?.removingPercentEncoding {
            responseString = decoded
        }

        print("\n" + " - >   RESPONSE BODY" + "\n" + responseString)
    }
}
