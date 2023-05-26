//
//  StoreBestSellersProvider.swift
//  Store
//
//  Created by Samuel Brasileiro on 26/05/23.
//

import Combine
import Service
import UIKit

class StoreBestSellersProvider: StoreBestSellersProviderProtocol {
    
    private var service: StoreServiceProtocol
    private var subscriptions: Set<AnyCancellable> = []
    
    init(service: StoreServiceProtocol) {
        self.service = service
    }
    
    func execute(completion: @escaping (Result<StoreBestSellersResponse, Error>) -> Void) {
        service.getBestSellers(completion: completion)
    }
}
