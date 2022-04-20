//
//  K.swift
//  ExpenseTracker
//
//  Created by Piyush Mandaliya on 2022-03-10.
//

import Foundation
import UIKit

struct K {
    
    static let mainBlack = UIColor(named: "mainBlack")!
    static let white = UIColor(named: "white")!
    static let blue = UIColor(named: "blue")!
    static let gray = UIColor(named: "gray")!
    static let green = UIColor(named: "green")!
    static let red = UIColor(named: "red")!
    static let pink = UIColor(named: "pink")!
    static let purple = UIColor(named: "purple")!
    static let colorBackground = UIColor(named: "ColorBackground")!
    static let colorBorder = UIColor(named: "ColorBorder")!
    
    static let colorPrimary = UIColor(named: "ColorPrimary")!
    static let colorPrimaryBackground = UIColor(named: "ColorPrimaryBackground")!
    static let colorSurface = UIColor(named: "ColorSurface")!
    static let colorSurfaceLight = UIColor(named: "ColorSurfaceLight")!
    static let colorTextPrimary = UIColor(named: "ColorTextPrimary")!
    static let colorTextSecondory = UIColor(named: "ColorTextSecondory")!
    
    static let categoryType = ["income", "expense"]
    
    static let accountImages = ["ac_1","ac_2","ac_3","ac_4","ac_5"
                                ,"ac_6","ac_7","ac_8","ac_9","ac_10"
                                ,"ac_11","ac_12","ac_13","ac_14","ac_15"
                                ,"ac_16","ac_17","ac_18","ac_19","ac_20"]
    
    static let defaultCategory = ["Food" : "cart.fill",
                                  "Restaurants" : "takeoutbag.and.cup.and.straw.fill",
                                  "Clothes" : "tshirt.fill",
                                  "Leisure" : "gamecontroller.fill",
                                  "Pets" : "pawprint.fill",
                                  "Petrol" : "fuelpump.fill",
                                  "House" : "house.fill",
                                  "Service" : "bolt.car.fill",
                                  "Mobile" : "iphone.homebutton",
                                  "Travel" : "briefcase.fill",
                                  "Internet" : "network"]
    
    
    static let onBoardingImage = ["note","categories","track"]
    static let onBoardingMessage: [String: String] = [
        "Note Your Expenses":"A smarter way to note your daily expenses that helps you to manage your money properly.",
        "Track by Category":"We can track our expenses category-wise by giving the details. It also helps you track the amount on which you spent most.",
        "Track and Analysis":"Tracking your daily expenses will help you avoid unwanted expenses."]
    
    
    enum TransactionType {
        case INCOME, EXPENSE, TRANSFER
    }
}

