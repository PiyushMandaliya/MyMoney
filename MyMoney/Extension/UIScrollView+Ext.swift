//
//  ScrollView+Ext.swift
//  MyMoney
//
//  Created by Piyush Mandaliya on 2022-05-30.
//

import UIKit

extension UIScrollView {
    
    func setUpOnBoardScrollView() {
        showsHorizontalScrollIndicator   = false
        showsVerticalScrollIndicator     = false
        contentInsetAdjustmentBehavior   = UIScrollView.ContentInsetAdjustmentBehavior.never
        isPagingEnabled                  = true
        isDirectionalLockEnabled         = true        
    }
}
