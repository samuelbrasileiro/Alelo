//
//  RemoveFromCartProvider.swift
//  Store
//
//  Created by Samuel Brasileiro on 28/05/23.
//

import Foundation

class RemoveFromCartProvider: RemoveFromCartProviderProtocol {
    
    private var service: CartDataServiceProtocol
    
    init(service: CartDataServiceProtocol) {
        self.service = service
    }
    
    func execute(product: StoreCartProduct, completion: @escaping (Result<Void, Error>) -> Void) {
        service.remove(product: product)
    }
}
