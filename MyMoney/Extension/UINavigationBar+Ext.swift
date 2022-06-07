//
//  UINavigationBar+Ext.swift
//  MyMoney
//
//  Created by Piyush Mandaliya on 2022-05-30.
//

import UIKit

extension UINavigationBar {
    
    func customNavigationBar() {
        self.tintColor                  = Color.textPrimary
        self.barTintColor               = Color.textPrimary
        self.isTranslucent              = false
        self.prefersLargeTitles         = false
 
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage                = UIImage()
        
        let appearance                  = UINavigationBarAppearance()
        appearance.backgroundColor      = Color.background
        appearance.titleTextAttributes  = [.foregroundColor: Color.textPrimary ?? .white]
        self.scrollEdgeAppearance       = appearance
        self.standardAppearance         = appearance
        
        self.titleTextAttributes        = [NSAttributedString.Key.foregroundColor: Color.textPrimary ?? .white]
    }
}
