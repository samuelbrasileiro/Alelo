//
//  StoreBestSellersViewState.swift
//  Store
//
//  Created by Samuel Brasileiro on 26/05/23.
//

import Foundation

enum StoreBestSellersViewState {
    case loading
    case success
    case error(Error)
}

enum StoreCartCountViewState {
    case success(Int)
    case error(Error)
}
