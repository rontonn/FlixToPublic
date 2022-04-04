//
//  
//  SignInWalletModels.swift
//  Flix
//
//  Created by Anton Romanov on 14.10.2021.
//
//

import UIKit

enum SignInWalletModels {
    // MARK: - InitialData
    enum InitialData {
        struct Request {}
        struct Response {
            let pageTitle: String
            let qrImage: UIImage?
        }
        struct ViewModel {
            let pageTitle: String
            let qrImage: UIImage?
        }
    }
}
