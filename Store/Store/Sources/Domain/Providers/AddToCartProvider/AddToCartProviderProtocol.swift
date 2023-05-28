//
//  AddToCartProviderProtocol.swift
//  Store
//
//  Created by Samuel Brasileiro on 28/05/23.
//

import Foundation

protocol AddToCartProviderProtocol {
    func execute(product: StoreCartProduct, completion: @escaping (Result<Void, Error>) -> Void)
}
