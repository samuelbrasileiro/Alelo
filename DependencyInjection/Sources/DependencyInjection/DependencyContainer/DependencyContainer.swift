//
//  DependencyContainer.swift
//  DependencyInjection
//
//  Created by Samuel Brasileiro on 25/05/23.
//

import Foundation

public final class DependencyContainer {
    private var dependencies: [DependencyKey: AnyObject] = [:]

    public func register<Value>(_ dependency: Value.Type,
                         factory: @escaping (DependencyResolver) -> Value) {
        let key = String(describing: Value.self)
        dependencies[.init(key: key, parameters: nil)] = factory as AnyObject
    }
    
    public func register<Value, Parameters>(_ dependency: Value.Type,
                                     factory: @escaping (DependencyResolver, Parameters) -> Value) {
        let key = String(describing: Value.self)
        let parameters = String(describing: Parameters.self)
        dependencies[.init(key: key, parameters: parameters)] = factory as AnyObject
    }
}

extension DependencyContainer: DependencyResolver {
    public func resolve<Value>(_ dependency: Value.Type) -> Value {
        let key = String(describing: Value.self)
        let factory = dependencies[.init(key: key, parameters: nil)] as? (DependencyResolver) -> Value
        precondition(factory != nil, "No dependency found for \(key) without parameters! must register a dependency before resolve.")
        return factory!(self)
    }
    
    public func resolve<Value, Parameters>(_ dependency: Value.Type, argument: Parameters) -> Value {
        let key = String(describing: Value.self)
        let parameters = String(describing: Parameters.self)
        let factory = dependencies[.init(key: key, parameters: parameters)] as? (DependencyResolver, Parameters) -> Value
        precondition(factory != nil, "No dependency found for \(key) with parameters of type \(parameters)! must register a dependency before resolve.")
        return factory!(self, argument)
    }
}
