//
//  StoreCartProduct.swift
//  Store
//
//  Created by Samuel Brasileiro on 28/05/23.
//

import Foundation

public struct StoreCartProduct {
    let chosenSize: StoreSize
    var quantity: Int = 1
    let item: StoreProduct
}
