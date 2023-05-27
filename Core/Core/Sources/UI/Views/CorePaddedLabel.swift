//
//  CorePaddedLabel.swift
//  Core
//
//  Created by Samuel Brasileiro on 27/05/23.
//

import UIKit

public class CorePaddedLabel: UILabel {
    public var padding: UIEdgeInsets = UIEdgeInsets.zero
    
    override public func drawText(in rect: CGRect) {
        let paddedRect = rect.inset(by: padding)
        super.drawText(in: paddedRect)
    }
    
    override public var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.width += padding.left + padding.right
        contentSize.height += padding.top + padding.bottom
        return contentSize
    }
}
