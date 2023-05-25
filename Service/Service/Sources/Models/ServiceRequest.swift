//
//  ServiceRequest.swift
//  Service
//
//  Created by Samuel Brasileiro on 25/05/23.
//

import Foundation

public protocol ServiceRequest {
    var path: String { get }
    var method: ServiceHTTPMethod { get }
    var headers: [String: String]? { get }
    var timeout: TimeInterval? { get }
    var queryItems: [URLQueryItem]? { get }
    var body: [String: Any]? { get }
}

public extension ServiceRequest {
    var headers: [String : String]? {
        return ["Content-Type": "application/json",
                "Accept": "application/json"]
    }
    
    var timeout: TimeInterval? {
        return 5
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var body: [String : Any]? {
        return nil
    }
}
