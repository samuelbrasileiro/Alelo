//
//  UIStackView+removeAllArrangedSubviews.swift
//  
//
//  Created by Samuel Brasileiro on 28/05/23.
//

import UIKit

public extension UIStackView {
    func removeAllArrangedSubviews() {
        for view in arrangedSubviews {
            removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}
