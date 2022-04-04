//
//  
//  ErrorRouter.swift
//  Flix
//
//  Created by Anton Romanov on 29.10.2021.
//
//

import UIKit

typealias ErrorRouterable = ErrorRoutingLogic & ErrorDataPassing

protocol ErrorRoutingLogic {
    // func routeToSomeWhere()
}

protocol ErrorDataPassing {
    var dataStore: ErrorDataStore? { get }
}

final class ErrorRouter: ErrorRouterable {
    // MARK: - Properties
    weak var viewController: ErrorViewController?
    var dataStore: ErrorDataStore?

    // MARK: - Routing
}

// MARK: - Private methods
private extension ErrorRouter {
    // MARK: - Navigation

    // MARK: - Passing data
}
