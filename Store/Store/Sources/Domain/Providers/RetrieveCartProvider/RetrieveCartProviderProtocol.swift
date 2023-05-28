//
//  RetrieveCartProviderProtocol.swift
//  Store
//
//  Created by Samuel Brasileiro on 28/05/23.
//

import Foundation

protocol RetrieveCartProviderProtocol {
    func execute(completion: @escaping (Result<[StoreCartProduct], Error>) -> Void)
}
