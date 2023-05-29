//
//  StoreProductDetailsViewState.swift
//  Store
//
//  Created by Samuel Brasileiro on 29/05/23.
//

import Foundation

enum StoreProductDetailsViewState {
    case success(product: StoreProduct)
    case error(Error)
}
