//
//  
//  TvRouter.swift
//  Flix
//
//  Created by Anton Romanov on 15.10.2021.
//
//

import UIKit

typealias TvRouterable = TvRoutingLogic & TvDataPassing

protocol TvRoutingLogic {
}

protocol TvDataPassing {
    var dataStore: TvDataStore? { get }
}

final class TvRouter: TvRouterable {
    // MARK: - Properties
    weak var viewController: TvViewController?
    var dataStore: TvDataStore?

    // MARK: - Routing
}

private extension TvRouter {
    // MARK: - Navigation
    // MARK: - Passing data
}
