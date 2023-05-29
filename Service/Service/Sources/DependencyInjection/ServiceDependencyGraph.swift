//
//  ServiceDependencyGraph.swift
//  Service
//
//  Created by Samuel Brasileiro on 26/05/23.
//

import DependencyInjection

public class ServiceDependencyGraph: DependencyGraph {
    
    private var assemblies: [Assembly] = [
        ServiceAssembly(),
        ApplicationServiceModelsAssembly()
    ]
    
    public init() { }
    
    public func build() -> [Assembly] {
        return assemblies
    }
}
