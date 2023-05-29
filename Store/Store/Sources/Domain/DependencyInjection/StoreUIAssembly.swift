//
//  StoreUIAssembly.swift
//  Store
//
//  Created by Samuel Brasileiro on 26/05/23.
//

import Core
import DependencyInjection

class StoreUIAssembly: Assembly {
    func assemble(container: DependencyContainer) {
        registerStoreBestSellersViewModel(container)
        registerStoreBestSellersViewController(container)
        registerStoreCartViewModel(container)
        registerStoreCartViewController(container)
        registerStoreProductDetailsViewModel(container)
        registerStoreProductDetailsViewController(container)
    }

    private func registerStoreBestSellersViewModel(_ container: DependencyContainer) {
        container.register(StoreBestSellersViewModel.self) { (container) in
            let bestSellersProvider = container.resolve(StoreBestSellersProviderProtocol.self)
            let addToCartProvider = container.resolve(AddToCartProviderProtocol.self)
            let retrieveCartCountProvider = container.resolve(RetrieveCartCountProviderProtocol.self)
            return StoreBestSellersViewModel(bestSellersProvider: bestSellersProvider,
                                             addToCartProvider: addToCartProvider,
                                             retrieveCartCountProvider: retrieveCartCountProvider)
        }
    }

    private func registerStoreBestSellersViewController(_ container: DependencyContainer) {
        container.register(StoreBestSellersViewController.self) { (container) in
            let viewModel = container.resolve(StoreBestSellersViewModel.self)
            return StoreBestSellersViewController(viewModel: viewModel)
        }
    }
    
    private func registerStoreCartViewModel(_ container: DependencyContainer) {
        container.register(StoreCartViewModel.self) { (container) in
            let updateCartProvider = container.resolve(UpdateCartProviderProtocol.self)
            let addToCartProvider = container.resolve(AddToCartProviderProtocol.self)
            let retrieveCartProvider = container.resolve(RetrieveCartProviderProtocol.self)
            return StoreCartViewModel(updateCartProvider: updateCartProvider,
                                      addToCartProvider: addToCartProvider,
                                      retrieveCartProvider: retrieveCartProvider)
        }
    }

    private func registerStoreCartViewController(_ container: DependencyContainer) {
        container.register(StoreCartViewController.self) { (container) in
            let viewModel = container.resolve(StoreCartViewModel.self)
            return StoreCartViewController(viewModel: viewModel)
        }
    }

    private func registerStoreProductDetailsViewModel(_ container: DependencyContainer) {
        container.register(StoreProductDetailsViewModel.self) { (container, product: StoreProduct) in
            let addToCartProvider = container.resolve(AddToCartProviderProtocol.self)
            let retrieveCartCountProvider = container.resolve(RetrieveCartCountProviderProtocol.self)
            return StoreProductDetailsViewModel(product: product,
                                                addToCartProvider: addToCartProvider,
                                                retrieveCartCountProvider: retrieveCartCountProvider)
        }
    }

    private func registerStoreProductDetailsViewController(_ container: DependencyContainer) {
        container.register(StoreProductDetailsViewController.self) { (container, product: StoreProduct) in
            let viewModel = container.resolve(StoreProductDetailsViewModel.self, argument: product)
            return StoreProductDetailsViewController(viewModel: viewModel)
        }
    }
}
