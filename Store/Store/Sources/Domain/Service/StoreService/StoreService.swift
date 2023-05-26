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
}
