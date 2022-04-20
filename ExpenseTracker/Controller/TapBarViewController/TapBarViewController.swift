//
//  TapBarViewController.swift
//  ExpenseTracker
//
//  Created by Piyush Mandaliya on 2022-03-16.
//

import UIKit

class TapBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setShadow()
    }
    
    private func setShadow(){
        tabBar.layer.shadowColor = UIColor.lightGray.cgColor
                tabBar.layer.shadowOpacity = 0.5
                tabBar.layer.shadowOffset = CGSize.zero
                tabBar.layer.shadowRadius = 2
                self.tabBar.layer.borderColor = UIColor.clear.cgColor
                self.tabBar.layer.borderWidth = 0
                self.tabBar.clipsToBounds = false
                UITabBar.appearance().shadowImage = UIImage()
                UITabBar.appearance().backgroundImage = UIImage()
    }
    
}

extension TapBarViewController: UITabBarControllerDelegate  {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
            return false // Make sure you want this as false
        }
        
        if fromView != toView {
            UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
        }
        
        return true
    }
}
