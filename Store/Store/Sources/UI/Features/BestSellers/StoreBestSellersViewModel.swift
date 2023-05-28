//
//  StoreBestSellersViewModel.swift
//  Store
//
//  Created by Samuel Brasileiro on 26/05/23.
//

import Combine
import Commons
import Core
import Foundation
import UIKit

class StoreBestSellersViewModel: ObservableObject {
    
    // MARK: - PUBLIC PROPERTIES
    
    let changeViewState: PassthroughSubject<StoreBestSellersViewState, Never> = .init()
    let cartCountViewState: PassthroughSubject<StoreCartCountViewState, Never> = .init()
    
    var products: [StoreProduct] {
        if filter == nil {
            return allProducts
        } else {
            return filteredProducts
        }
    }
    
    var filter: StoreFilterKind?
    
    // MARK: - PRIVATE PROPERTIES
    
    private let bestSellersProvider: StoreBestSellersProviderProtocol
    private let addToCartProvider: AddToCartProviderProtocol
    private let retrieveCartCountProvider: RetrieveCartCountProviderProtocol
    private var allProducts: [StoreProduct] = []
    private var filteredProducts: [StoreProduct] = []
    
    // MARK: - INITIALIZERS
    
    init(bestSellersProvider: StoreBestSellersProviderProtocol,
         addToCartProvider: AddToCartProviderProtocol,
         retrieveCartCountProvider: RetrieveCartCountProviderProtocol) {
        self.bestSellersProvider = bestSellersProvider
        self.addToCartProvider = addToCartProvider
        self.retrieveCartCountProvider = retrieveCartCountProvider
    }
    
    // MARK: - PUBLIC METHODS
    
    func setup() {
        retrieveBestSellers()
        retrieveCartCount()
        changeViewState.send(.loading)
    }
    
    func setFilter(kind: StoreFilterKind) {
        filter = kind
        applyFilter()
    }
    
    func removeFilter() {
        filter = nil
        applyFilter()
    }
    
    func retrieveCartCount() {
        retrieveCartCountProvider.execute { [weak self] result in
            switch result {
            case .success(let count):
                self?.cartCountViewState.send(.success(count))
            case .failure(let error):
                self?.cartCountViewState.send(.error(error))
            }
        }
    }
    
    func addToCart(size: StoreSize, product: StoreProduct) {
        addToCartProvider.execute(product: .init(chosenSize: size, item: product)) { [weak self] result in
            if case .failure(let error) = result {
                self?.changeViewState.send(.error(error))
            }
        }
    }
    
    // MARK: - PRIVATE METHODS
    
    private func retrieveBestSellers() {
        bestSellersProvider.execute { [weak self] result in
            switch result {
            case .success(let bestSellers):
                self?.handleRetrieveBestSellersSuccess(bestSellers)
            case .failure(let error):
                self?.changeViewState.send(.error(error))
            }
        }
    }
    
    private func handleRetrieveBestSellersSuccess(_ model: StoreBestSellersResponse) {
        self.allProducts = model.products
        applyFilter()
        changeViewState.send(.success)
    }
    
    private func applyFilter() {
        if let filter = filter {
            switch filter {
            case .inPromotion:
                filteredProducts = allProducts.filter { $0.onSale }
            }
        } else {
            filteredProducts = []
        }
        
        changeViewState.send(.success)
    }
}
