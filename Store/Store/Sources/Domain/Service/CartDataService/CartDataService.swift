//
//  CartDataService.swift
//  Store
//
//  Created by Samuel Brasileiro on 28/05/23.
//

import Foundation

public class CartDataService: CartDataServiceProtocol {
    
    // MARK: - PUBLIC PROPERTIES
    
    static public let shared = CartDataService()
    
    // MARK: - PRIVATE PROPERTIES
    
    private var products: [StoreCartProduct] = []
    
    // MARK: - INITIALIZERS
    
    private init() { }
    
    // MARK: - PUBLIC METHODS
    
    func add(product: StoreCartProduct) {
        if let index = products.firstIndex(where: {$0.chosenSize.sku == product.chosenSize.sku}) {
            products[index].quantity += 1
        } else {
            products.append(product)
        }
    }
    
    func remove(product: StoreCartProduct) {
        guard let index = products.firstIndex(where: {$0.chosenSize.sku == product.chosenSize.sku}),
              let product = products[safe: index] else { return }
        if product.quantity > 0 {
            products[index].quantity -= 1
        } else {
            products.remove(at: index)
        }
    }
    
    func getAll() -> [StoreCartProduct] {
        return products
    }
}
