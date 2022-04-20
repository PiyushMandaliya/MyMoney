//
//  Extensions.swift
//  ExpenseTracker
//
//  Created by Piyush Mandaliya on 2022-03-29.
//


import UIKit

extension UIImage {
    
    func imageWithColor(color1: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color1.setFill()
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }    
}


extension UINavigationBar {
    func customNavigationBar() {
        // color for button images, indicators and etc.
        self.tintColor = UIColor(named: "ColorTextPrimary")
        
        // color for background of navigation bar
        // but if you use larget titles, then in viewDidLoad must write
        // navigationController?.view.backgroundColor = // your color
        self.barTintColor = UIColor(named: "ColorTextPrimary")
        self.isTranslucent = false
        
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        
        
        // for larget titles
        self.prefersLargeTitles = false
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: "ColorBackground")
        appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "ColorTextPrimary") ?? .white]
        
        self.scrollEdgeAppearance = appearance
        self.standardAppearance = appearance
        
        // color for standard title label
        self.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "ColorTextPrimary") ?? .white]
        
        // remove bottom line/shadow
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
    }
}

extension Double {
    var decimalPlaces: Int {
        let decimals = String(self).split(separator: ".")[1]
        return decimals == "0" ? 0 : decimals.count
    }
}
