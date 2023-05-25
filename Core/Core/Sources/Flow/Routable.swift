//
//  Routable.swift
//  MeusTopArtistas
//
//  Created by Samuel Brasileiro on 25/05/23.
//

import UIKit

public protocol Routable {
    associatedtype Route: RouteProtocol
    
    func getTransition(to route: Route) -> UIViewController?
}
