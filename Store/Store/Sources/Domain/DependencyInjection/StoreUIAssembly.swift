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
}
