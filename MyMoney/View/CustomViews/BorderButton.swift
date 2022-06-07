//
//  BorderButton.swift
//  ExpenseTracker
//
//  Created by Piyush Mandaliya on 2022-04-04.
//

import UIKit

@IBDesignable
class BorderButton: UIButton {
    
    @IBInspectable var borderWidth: CGFloat = 0.0{
        didSet{
            self.layer.borderWidth = borderWidth
            self.layer.cornerRadius = 3
        }
    }
    
    @IBInspectable var borderColor: UIColor = Color.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *) {
            if (traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection)) {
                // ColorUtils.loadCGColorFromAsset returns cgcolor for color name
                layer.borderColor = borderColor.cgColor
            }
        }
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    
}
