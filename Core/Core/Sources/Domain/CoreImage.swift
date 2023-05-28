//
//  CoreImage.swift
//  Core
//
//  Created by Samuel Brasileiro on 28/05/23.
//

import UIKit

public enum CoreImage {
    case unavailableImage
    
    public var image: UIImage {
        getImageAsset().image
    }
    
    private func getImageAsset() -> ImageAsset {
        switch self {
        case .unavailableImage: return Asset.unavailableImage
        }
    }
}
