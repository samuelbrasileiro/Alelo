//
//  NetworkServiceProtocol.swift
//  Service
//
//  Created by Samuel Brasileiro on 25/05/23.
//

import UIKit

public protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(_ type: T.Type,
                             from request: ServiceRequest,
                             completion: @escaping (Result<T, ServiceError>) -> Void)
}
