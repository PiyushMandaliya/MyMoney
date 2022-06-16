//
//  UIView+Ext.swift
//  MyMoney
//
//  Created by Piyush Mandaliya on 2022-05-30.
//

import UIKit

extension UIView {
    
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
