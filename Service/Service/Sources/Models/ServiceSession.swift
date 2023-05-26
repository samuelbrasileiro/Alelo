//
//  ServiceSession.swift
//  Service
//
//  Created by Samuel Brasileiro on 25/05/23.
//

import Foundation

public protocol ServiceSessionProtocol {
    var baseURL: String { get }
    func buildFinalPath(from request: ServiceRequest) -> String
}

struct ApplicationServiceSession: ServiceSessionProtocol {
    var baseURL: String {
        return "http://www.mocky.io/"
    }
    
    func buildFinalPath(from request: ServiceRequest) -> String {
        return baseURL + request.path
    }
}
