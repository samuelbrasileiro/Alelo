//
//  StoreRequest.swift
//  Store
//
//  Created by Samuel Brasileiro on 25/05/23.
//

import Service

class StoreRequest: ServiceRequest {
    
    enum Request {
        case bestSellers
    }
    
    let req: Request
    
    init(_ req: Request) {
        self.req = req
    }
    
    var path: String {
        switch req {
        case .bestSellers: return "v2/59b6a65a0f0000e90471257d"
        }
    }
    
    var method: Service.ServiceHTTPMethod {
        switch req {
        case .bestSellers: return .get
        }
    }
}
