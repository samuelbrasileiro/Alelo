//
//  StoreCartObserver.swift
//  Store
//
//  Created by Samuel Brasileiro on 28/05/23.
//

import Combine

class StoreCartObserver {
    
    // MARK: - PUBLIC PROPERTIES
    
    let didUpdateCart: PassthroughSubject<Void, Never> = .init()
    
    static let shared: StoreCartObserver = .init()
        
    // MARK: - LIFE CYCLE
    
    private init() { }
}
