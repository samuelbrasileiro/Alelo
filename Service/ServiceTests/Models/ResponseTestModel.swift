//
//  ResponseTestModel.swift
//  Service
//
//  Created by Samuel Brasileiro on 26/05/23.
//

import Foundation

struct ResponseTestModel: Codable {
    var name: String
}


struct ResponseProductsTestModel: Codable {
    var products: [ResponseTestModel]
}
