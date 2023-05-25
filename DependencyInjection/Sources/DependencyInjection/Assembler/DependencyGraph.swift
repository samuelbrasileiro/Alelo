//
//  DependencyGraph.swift
//  DependencyInjection
//
//  Created by Samuel Brasileiro on 25/05/23.
//

import Foundation

public protocol DependencyGraph: AnyObject {
    func build() -> [Assembly]
}
