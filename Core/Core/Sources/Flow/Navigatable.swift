//
//  Navigatable.swift
//  MeusTopArtistas
//
//  Created by Samuel Brasileiro on 25/05/23.
//

import Foundation

public typealias CoreCoordinator = Coordinator & Navigatable & Routable

public protocol Navigatable {
    associatedtype Route: RouteProtocol
    func navigate(to route: Route)
    func goBack(animated: Bool)
}

public extension Navigatable where Self: Coordinator,
                                   Self: Routable {
    func navigate(to route: Route) {
        guard let viewController = getTransition(to: route) else { return }
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func goBack(animated: Bool) {
        navigationController.popViewController(animated: animated)
    }
}
