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
    private var allProducts: [StoreProduct] = []
    private var filteredProducts: [StoreProduct] = []
    
    // MARK: - INITIALIZERS
    
    init(bestSellersProvider: StoreBestSellersProviderProtocol) {
        self.bestSellersProvider = bestSellersProvider
    }
    
    // MARK: - PUBLIC METHODS
    
    func setup() {
        retrieveBestSellers()
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
