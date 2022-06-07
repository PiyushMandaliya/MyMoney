//
//  AppManager.swift
//  ExpenseTracker
//
//  Created by Piyush Mandaliya on 2022-03-15.
//

import Foundation

class AppManager {
    static let shared = AppManager()
    
    var isFirstLaunch: Bool {
        get {
            !UserDefaults.standard.bool(forKey: #function)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: #function)
        }
    }
}
