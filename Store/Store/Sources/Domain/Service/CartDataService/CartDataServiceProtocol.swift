//
//  CartDataServiceProtocol.swift
//  Store
//
//  Created by Samuel Brasileiro on 28/05/23.
//

import Foundation

protocol CartDataServiceProtocol {
    func add(product: StoreCartProduct)
    func update(product: StoreCartProduct)
    func getAll() -> [StoreCartProduct]
    func getCount() -> Int
}
