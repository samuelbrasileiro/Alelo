//
//  StoreBestSellersProviderProtocol.swift
//  Store
//
//  Created by Samuel Brasileiro on 26/05/23.
//

import Foundation

protocol StoreBestSellersProviderProtocol {
    func execute(completion: @escaping (Result<StoreBestSellersResponse, Error>) -> Void)
}
