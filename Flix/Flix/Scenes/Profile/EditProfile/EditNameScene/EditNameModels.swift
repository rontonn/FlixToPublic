//
//  
//  EditNameModels.swift
//  Flix
//
//  Created by Anton Romanov on 05.11.2021.
//
//

enum EditNameModels {
    // MARK: - InitialData
    enum InitialData {
        struct Request {}
        struct Response {
            let name: String?
        }
        struct ViewModel {
            let name: String?
        }
    }
    enum Result {
        struct Request {
            let newName: String?
        }
        struct Response {}
        struct ViewModel {}
    }
}
