//
//  StoreTestsIntegrator.swift
//  ModuleIntegrator
//
//  Created by Samuel Brasileiro on 29/05/23.
//

import DependencyInjection
import Service
import Store

public class StoreTestsIntegrator: ModuleIntegrator {
    
    public static func build() -> DependencyResolver {
        let assembler = Assembler()
        let dependencyGraphs: [DependencyGraph] = [
            ServiceDependencyGraph(),
            StoreDependencyGraph()
        ]
        for graph in dependencyGraphs {
            assembler.addContents(of: graph)
        }
        return assembler.resolver
    }
}
