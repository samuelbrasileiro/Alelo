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
        StoreCartObserver.shared.didUpdateCart.send(())
    }
    
    func update(product: StoreCartProduct) {
        guard let index = products.firstIndex(where: {$0.chosenSize.sku == product.chosenSize.sku}) else { return }
        if product.quantity > 0 {
            products[index].quantity = product.quantity
        } else {
            products.remove(at: index)
        }
        StoreCartObserver.shared.didUpdateCart.send(())
    }
    
    func getAll() -> [StoreCartProduct] {
        return products
    }
    
    func getCount() -> Int {
        let count = products.reduce(0) {partialResult, item in
            return partialResult + item.quantity
        }
        return count
    }
}
