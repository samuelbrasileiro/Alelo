//
//  TestRequest.swift
//  Service
//
//  Created by Samuel Brasileiro on 26/05/23.
//

import Service

class TestRequest: ServiceRequest {
    
    enum Request {
        case response_sucessful
        case wrong_path
    }
    
    let req: Request
    
    init(_ req: Request) {
        self.req = req
    }
    
    var path: String {
        switch req {
        case .response_sucessful: return "v2/59b6a65a0f0000e90471257d"
        case .wrong_path: return "v2/error"
        }
    }
    
    var method: Service.ServiceHTTPMethod {
        switch req {
        case .response_sucessful,
                .wrong_path: return .get
        }
    }
}
