//
//  RetrieveCartProvider.swift
//  Store
//
//  Created by Samuel Brasileiro on 28/05/23.
//

import Foundation

class RetrieveCartProvider: RetrieveCartProviderProtocol {
    
    private var service: CartDataServiceProtocol
    
    init(service: CartDataServiceProtocol) {
        self.service = service
    }
    
    func execute(completion: @escaping (Result<[StoreCartProduct], Error>) -> Void) {
        let products = service.getAll()
        completion(.success(products))
    }
}
