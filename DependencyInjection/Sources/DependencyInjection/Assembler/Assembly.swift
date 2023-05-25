//
//  Assembly.swift
//  DependencyInjection
//
//  Created by Samuel Brasileiro on 25/05/23.
//

import Foundation

public protocol Assembly {
    func assemble(container: DependencyContainer)
}
