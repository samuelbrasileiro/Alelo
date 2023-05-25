//
//  DependencyResolver.swift
//  DependencyInjection
//
//  Created by Samuel Brasileiro on 25/05/23.
//

import Foundation

public protocol DependencyResolver {
    func resolve<Value>(_ dependency: Value.Type) -> Value
    func resolve<Value, Parameters>(_ dependency: Value.Type, argument: Parameters) -> Value
}
