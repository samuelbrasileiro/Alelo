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
    
    // MARK: - PUBLIC ATTRIBUTES
    
    let changeViewState: PassthroughSubject<StoreBestSellersViewState, Never> = .init()
    var products: [StoreProduct] = []
    
    // MARK: - PRIVATE ATTRIBUTES
    
    private let bestSellersProvider: StoreBestSellersProviderProtocol
    
    // MARK: - INITIALIZERS
    
    init(bestSellersProvider: StoreBestSellersProviderProtocol) {
        self.bestSellersProvider = bestSellersProvider
    }
    
    // MARK: - PUBLIC METHODS
    
    func setup() {
        retrieveBestSellers()
        changeViewState.send(.loading)
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
        self.products = model.products
        changeViewState.send(.success)
    }
}
