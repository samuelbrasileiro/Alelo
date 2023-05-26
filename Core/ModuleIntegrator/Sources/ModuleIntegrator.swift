//
//  ModuleIntegrator.swift
//  ModuleIntegrator
//
//  Created by Samuel Brasileiro on 26/05/23.
//

import DependencyInjection

protocol ModuleIntegrator {
    static func build() -> DependencyResolver
}
