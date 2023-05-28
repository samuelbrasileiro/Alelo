//
//  RetrieveCartCountProvider.swift
//  Store
//
//  Created by Samuel Brasileiro on 28/05/23.
//

import Foundation

class RetrieveCartCountProvider: RetrieveCartCountProviderProtocol {
    
    private var service: CartDataServiceProtocol
    
    init(service: CartDataServiceProtocol) {
        self.service = service
    }
    
    func execute(completion: @escaping (Result<Int, Error>) -> Void) {
        let count = service.getCount()
        completion(.success(count))
    }
}
