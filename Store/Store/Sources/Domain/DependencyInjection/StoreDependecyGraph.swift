//
//  StoreDependencyGraph.swift
//  Store
//
//  Created by Samuel Brasileiro on 26/05/23.
//

import DependencyInjection

public class StoreDependencyGraph: DependencyGraph {
    
    private var assemblies: [Assembly] = [
        StoreDomainAssembly(),
        StoreUIAssembly()
    ]
    
    public init() { }
    
    public func build() -> [Assembly] {
        return assemblies
    }
}
