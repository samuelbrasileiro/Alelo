//
//  StoreCartProduct.swift
//  Store
//
//  Created by Samuel Brasileiro on 28/05/23.
//

import Foundation

public struct StoreCartProduct {
    var chosenSize: StoreSize
    var quantity: Int = 1
    let item: StoreProduct
    
    public static var dirty: StoreCartProduct {
        return .init(chosenSize: .dirty, item: .dirty)
    }
}

// MARK: - Equatable

extension StoreCartProduct: Equatable {
    public static func == (lhs: StoreCartProduct, rhs: StoreCartProduct) -> Bool {
        lhs.chosenSize.sku == rhs.chosenSize.sku
    }
}
