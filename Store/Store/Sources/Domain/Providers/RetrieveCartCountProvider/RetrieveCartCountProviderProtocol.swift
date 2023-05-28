//
//  RetrieveCartCountProviderProtocol.swift
//  Store
//
//  Created by Samuel Brasileiro on 28/05/23.
//

import Foundation

protocol RetrieveCartCountProviderProtocol {
    func execute(completion: @escaping (Result<Int, Error>) -> Void)
}
