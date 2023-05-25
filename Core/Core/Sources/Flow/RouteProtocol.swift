//
//  RouteProtocol.swift
//  MeusTopArtistas
//
//  Created by Samuel Brasileiro on 25/05/23.
//

import Foundation

public protocol RouteProtocol {
    var id: String { get }
}

public extension RouteProtocol {
    var id: String {
        String(describing: self)
    }
}
