//
//  StoreDomainAssembler.swift
//  Store
//
//  Created by Samuel Brasileiro on 26/05/23.
//

import DependencyInjection
import Service

class StoreDomainAssembly: Assembly {
    open func assemble(container: DependencyContainer) {
        registerStoreService(container)
        registerStoreBestSellersProvider(container)
    }

    private func registerStoreService(_ container: DependencyContainer) {
        container.register(StoreServiceProtocol.self) { resolver in
            let networkService = resolver.resolve(NetworkServiceProtocol.self)
            return StoreService(networkService: networkService)
        }
    }
    
    private func registerStoreBestSellersProvider(_ container: DependencyContainer) {
        container.register(StoreBestSellersProviderProtocol.self) { resolver in
            let service = resolver.resolve(StoreServiceProtocol.self)
            return StoreBestSellersProvider(service: service)
        }
    }
}
