//
//  StoreProductDetailsViewModel.swift
//  Store
//
//  Created by Samuel Brasileiro on 29/05/23.
//

import Combine
import Core
import UIKit

class StoreProductDetailsViewModel {
    
    // MARK: - PULIC PROPERTIES
    
    let product: StoreProduct
    let changeViewState: PassthroughSubject<StoreProductDetailsViewState, Never> = .init()
    let cartCountViewState: PassthroughSubject<StoreCartCountViewState, Never> = .init()
    
    // MARK: - PRIVATE PROPERTIES
    
    private let addToCartProvider: AddToCartProviderProtocol
    private let retrieveCartCountProvider: RetrieveCartCountProviderProtocol
    
    // MARK: - INITIALIZERS
    
    init(product: StoreProduct,
         addToCartProvider: AddToCartProviderProtocol,
         retrieveCartCountProvider: RetrieveCartCountProviderProtocol) {
        self.product = product
        self.addToCartProvider = addToCartProvider
        self.retrieveCartCountProvider = retrieveCartCountProvider
    }
    
    // MARK: - PUBLIC METHODS
    
    func setup() {
        retrieveCartCount()
        changeViewState.send(.success(product: product))
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
}
