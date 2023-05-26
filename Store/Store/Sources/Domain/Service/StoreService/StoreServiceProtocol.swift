//
//  StoreServiceProtocol.swift
//  Store
//
//  Created by Samuel Brasileiro on 26/05/23.
//

import Foundation

protocol StoreServiceProtocol {
    func getBestSellers(completion: @escaping (Result<StoreBestSellersResponse, Error>) -> Void)
}
