//
//  StoreCoordinator.swift
//  Store
//
//  Created by Samuel Brasileiro on 26/05/23.
//

import Core
import DependencyInjection
import UIKit

public protocol StoreCoordinatorDelegate: AnyObject { }

public final class StoreCoordinator: CoreCoordinator {
    
    public enum Route: RouteProtocol {
        case productDetails
        case bestSellers
        case cart
    }
    
    // MARK: - PUBLIC PROPERTIES
    
    public var navigationController: UINavigationController
    weak public var parentCoordinator: (any Coordinator)?
    public var childCoordinators: [any Coordinator] = []
    
    public weak var delegate: StoreCoordinatorDelegate?
    let resolver: DependencyResolver
    
    // MARK: - INITIALIZER
    
    public required init(resolver: DependencyResolver,
                         navigationController: UINavigationController) {
        self.resolver = resolver
        self.navigationController = navigationController
    }
    
    // MARK: - PUBLIC METHODS
    
    public func start() { 
        startToRoute()
    }
    
    public func startToRoute(_ route: Route? = nil) { 
        navigate(to: route ?? .bestSellers)
    }
    
    public func getTransition(to route: Route) -> UIViewController? {
        switch route {
        case .bestSellers: return makeStoreBestSellersViewController()
        case .cart: return UIViewController()
        case .productDetails: return UIViewController()
        }
    }
}
