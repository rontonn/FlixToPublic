//
//  
//  MusicRouter.swift
//  Flix
//
//  Created by Anton Romanov on 15.10.2021.
//
//

import UIKit

typealias MusicRouterable = MusicRoutingLogic & MusicDataPassing

protocol MusicRoutingLogic {
}

protocol MusicDataPassing {
    var dataStore: MusicDataStore? { get }
}

final class MusicRouter: MusicRouterable {
    // MARK: - Properties
    weak var viewController: MusicViewController?
    var dataStore: MusicDataStore?

    // MARK: - Routing
}

private extension MusicRouter {
    // MARK: - Navigation

    // MARK: - Passing data
}
