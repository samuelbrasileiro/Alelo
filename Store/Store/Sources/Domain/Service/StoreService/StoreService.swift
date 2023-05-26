//
//  StoreService.swift
//  Store
//
//  Created by Samuel Brasileiro on 26/05/23.
//

import Service

class StoreService: StoreServiceProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getBestSellers(completion: @escaping (Result<StoreBestSellersResponse, Error>) -> Void) {
        networkService.fetch(StoreBestSellersResponse.self, from: StoreRequest(.bestSellers)){ result in
            completion(result.flatMapError { serviceError in
                    .failure(serviceError)
            })
        }
    }
}
