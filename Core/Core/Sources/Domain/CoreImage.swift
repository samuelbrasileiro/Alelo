//
//  CoreImage.swift
//  Core
//
//  Created by Samuel Brasileiro on 28/05/23.
//

import UIKit

public class CoreImage {
    
    public enum Name {
        case unavailableImage
    }
    
    public var image: UIImage {
        getImageAsset().image
    }
    
    private let name: CoreImage.Name
    
    public init(named name: CoreImage.Name) {
        self.name = name
    }
    
    private func getImageAsset() -> ImageAsset {
        switch name {
        case .unavailableImage: return Asset.unavailableImage
        }
    }
}
