//
//  StoreProduct.swift
//  Store
//
//  Created by Samuel Brasileiro on 26/05/23.
//

import Foundation

// MARK: - StoreProduct
public struct StoreProduct: Codable {
    var name: String
    var style: String?
    var codeColor: String?
    var colorSlug: String?
    var color: String?
    var onSale: Bool
    var regularPrice: String
    var actualPrice: String
    var discountPercentage: String
    var installments: String
    var image: String
    var sizes: [StoreSize]

    enum CodingKeys: String, CodingKey {
        case name, style
        case codeColor = "code_color"
        case colorSlug = "color_slug"
        case color
        case onSale = "on_sale"
        case regularPrice = "regular_price"
        case actualPrice = "actual_price"
        case discountPercentage = "discount_percentage"
        case installments, image, sizes
    }
    
    public static var dirty: StoreProduct {
        return .init(name: "",
                     style: "",
                     codeColor: "",
                     colorSlug: "",
                     color: "",
                     onSale: false,
                     regularPrice: "",
                     actualPrice: "",
                     discountPercentage: "",
                     installments: "",
                     image: "",
                     sizes: [])
    }
}

// MARK: - StoreSize
struct StoreSize: Codable {
    var available: Bool
    var size: String
    var sku: String
    
    public static var dirty: StoreSize {
        return .init(available: false,
                     size: "",
                     sku: "")
    }
}
