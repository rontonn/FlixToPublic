//
//  
//  MoreEpisodesRouter.swift
//  Flix
//
//  Created by Anton Romanov on 25.10.2021.
//
//

import UIKit

typealias MoreEpisodesRouterable = MoreEpisodesRoutingLogic & MoreEpisodesDataPassing

protocol MoreEpisodesRoutingLogic {
    // func routeToSomeWhere()
}

protocol MoreEpisodesDataPassing {
    var dataStore: MoreEpisodesDataStore? { get }
}

final class MoreEpisodesRouter: MoreEpisodesRouterable {
    // MARK: - Properties
    weak var viewController: MoreEpisodesViewController?
    var dataStore: MoreEpisodesDataStore?

    // MARK: - Routing
}

// MARK: - Private methods
private extension MoreEpisodesRouter {
    // MARK: - Navigation

    // MARK: - Passing data
}
