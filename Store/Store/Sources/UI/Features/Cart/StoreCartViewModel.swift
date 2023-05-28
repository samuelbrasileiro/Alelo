//
//  StoreCartViewModel.swift
//  Store
//
//  Created by Samuel Brasileiro on 28/05/23.
//

import Combine
import Commons
import Core
import Foundation
import UIKit

class StoreCartViewModel: ObservableObject {
    
    // MARK: - PUBLIC PROPERTIES
    
    let changeViewState: PassthroughSubject<StoreCartViewState, Never> = .init()
    var products: [StoreCartProduct] = []
    
    // MARK: - PRIVATE PROPERTIES
    
    private let updateCartProvider: UpdateCartProviderProtocol
    private let addToCartProvider: AddToCartProviderProtocol
    private let retrieveCartProvider: RetrieveCartProviderProtocol
    private var allProducts: [StoreProduct] = []
    private var filteredProducts: [StoreProduct] = []
    
    // MARK: - INITIALIZERS
    
    init(updateCartProvider: UpdateCartProviderProtocol,
         addToCartProvider: AddToCartProviderProtocol,
         retrieveCartProvider: RetrieveCartProviderProtocol) {
        self.updateCartProvider = updateCartProvider
        self.addToCartProvider = addToCartProvider
        self.retrieveCartProvider = retrieveCartProvider
    }
    
    // MARK: - PUBLIC METHODS
    
    func setup() {
        retrieveCartProducts()
        changeViewState.send(.loading)
    }
    
    func retrieveCartProducts() {
        retrieveCartProvider.execute { [weak self] result in
            switch result {
            case .success(let products):
                self?.handleRetrieveCartProductsSuccess(products)
            case .failure(let error):
                self?.changeViewState.send(.error(error))
            }
        }
    }
    
    func updateCart(product: StoreCartProduct) {
        updateCartProvider.execute(product: product) { [weak self] result in
            if case .failure(let error) = result {
                self?.changeViewState.send(.error(error))
            }
        }
    }
    
    // MARK: - PRIVATE METHODS
    
    private func handleRetrieveCartProductsSuccess(_ products: [StoreCartProduct]) {
        self.products = products
        changeViewState.send(.success)
    }
    
    private func handleRemoveProductSuccess(_ indexPath: IndexPath) {
        products.remove(at: indexPath.row)
        changeViewState.send(.removeProduct(indexPath: indexPath))
    }
}
