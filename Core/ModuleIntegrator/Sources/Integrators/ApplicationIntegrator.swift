//
//  ApplicationIntegrator.swift
//  ModuleIntegrator
//
//  Created by Samuel Brasileiro on 26/05/23.
//

import Core
import DependencyInjection
import Store
import Service

public class ApplicationIntegrator: ModuleIntegrator {
    
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
