//
//  Collection+safeSubscript.swift
//  
//
//  Created by Samuel Brasileiro on 26/05/23.
//

import Foundation

extension Collection {
    public subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
