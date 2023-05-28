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
        registerCartDataService(container)
        registerStoreBestSellersProvider(container)
        registerAddToCartProvider(container)
        registerRemoveFromCartProvider(container)
    }

    private func registerStoreService(_ container: DependencyContainer) {
        container.register(StoreServiceProtocol.self) { resolver in
            let networkService = resolver.resolve(NetworkServiceProtocol.self)
            return StoreService(networkService: networkService)
        }
    }
    
    private func registerCartDataService(_ container: DependencyContainer) {
        container.register(CartDataService.self) { resolver in
            return CartDataService.shared
        }
    }
    
    private func registerStoreBestSellersProvider(_ container: DependencyContainer) {
        container.register(StoreBestSellersProviderProtocol.self) { resolver in
            let service = resolver.resolve(StoreServiceProtocol.self)
            return StoreBestSellersProvider(service: service)
        }
    }
    
    private func registerAddToCartProvider(_ container: DependencyContainer) {
        container.register(AddToCartProviderProtocol.self) { resolver in
            let service = resolver.resolve(CartDataServiceProtocol.self)
            return AddToCartProvider(service: service)
        }
    }
    
    private func registerRemoveFromCartProvider(_ container: DependencyContainer) {
        container.register(RemoveFromCartProviderProtocol.self) { resolver in
            let service = resolver.resolve(CartDataServiceProtocol.self)
            return RemoveFromCartProvider(service: service)
        }
    }
}
