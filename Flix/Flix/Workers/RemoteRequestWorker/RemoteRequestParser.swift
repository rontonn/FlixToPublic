//
//  RemoteRequestParser.swift
//  Flix
//
//  Created by Anton Romanov on 03.12.2021.
//

import Foundation

struct RemoteRequestParser<T: Decodable> {
    // MARK: - Public methods
    func parseFrom(_ data: Data) -> T? {
        var parsedData: T?
        do {
            parsedData = try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Decodable: 'parse()' failed to parse data.")
        }
        return parsedData
    }
}
