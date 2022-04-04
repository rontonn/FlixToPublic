//
//  
//  AlertRouter.swift
//  Flix
//
//  Created by Anton Romanov on 11.11.2021.
//
//

import UIKit

typealias AlertRouterable = AlertRoutingLogic & AlertDataPassing

protocol AlertRoutingLogic {
}

protocol AlertDataPassing {
    var dataStore: AlertDataStore? { get }
}

final class AlertRouter: AlertRouterable {
    // MARK: - Properties
    weak var viewController: AlertViewController?
    var dataStore: AlertDataStore?

    // MARK: - Routing
}

// MARK: - Private methods
private extension AlertRouter {
    // MARK: - Navigation

    // MARK: - Passing data
}
