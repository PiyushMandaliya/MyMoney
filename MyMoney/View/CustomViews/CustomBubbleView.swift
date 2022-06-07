//
//  CustomBubbleView.swift
//  MyMoney
//
//  Created by Piyush Mandaliya on 2022-04-20.
//

import UIKit

class CustomBudgetSpentView: UIView {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *) {
            if (traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection)) {
                DispatchQueue.main.async {
                    self.setNeedsDisplay()
                }
            }
        }
    }
    
    @IBInspectable var bgColor: UIColor = Color.clear {
        didSet {
            self.layer.backgroundColor = bgColor.cgColor
        }
    }
    
    override func draw(_ rect: CGRect) {
        let bezierPath = UIBezierPath()
        bezierPath.lineWidth = 0 // 3
        
        let width = rect.width
        let height = rect.height
        
        bezierPath.move(to: CGPoint(x: 0, y: 0))
        bezierPath.addLine(to: CGPoint(x: width, y: 0))
        bezierPath.addLine(to: CGPoint(x: width, y: height))
        bezierPath.addLine(to: CGPoint(x: width - 10, y: height - 7))
        bezierPath.addLine(to: CGPoint(x: 0, y: height - 7))
        bezierPath.close()
        backgroundColor = bgColor
        backgroundColor?.setFill()
        bezierPath.fill()
        bezierPath.stroke()
    }
}
