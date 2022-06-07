//
//  UIImage+Ext.swift
//  MyMoney
//
//  Created by Piyush Mandaliya on 2022-05-30.
//

import UIKit

extension UIImage {
    
    func imageWithColor(color1: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color1.setFill()
        
        let context     = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        let rect        = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)
        
        let newImage    = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
    public convenience init?(bounds: CGRect, colors: [UIColor], value: CGFloat) {
        let gradientLayer           = CAGradientLayer()
        gradientLayer.frame         = bounds
        gradientLayer.colors        = colors.map({ $0.cgColor })
        
        gradientLayer.startPoint    = CGPoint(x: 0.0, y: abs(value*0.75) );
        gradientLayer.endPoint      = CGPoint(x: 1.0, y: abs(value*0.75));
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image                   = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage           = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
