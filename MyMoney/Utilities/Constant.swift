//
//  Constant.swift
//  MyMoney
//
//  Created by Piyush Mandaliya on 2022-05-30.
//

import UIKit

enum TransactionType {
    static let Income = "income"
    static let Expense = "expense"
    static let Transfer = "transfer"
}

enum onBoarding {
    static let images = ["note","categories","track"]
    
    static let messages: [String: String] = [
        "Note Your Expenses":"A smarter way to note your daily expenses that helps you to manage your money properly.",
        "Track by Category":"We can track our expenses category-wise by giving the details. It also helps you track the amount on which you spent most.",
        "Track and Analysis":"Tracking your daily expenses will help you avoid unwanted expenses."]
}

enum defaulData {
    
    static let accountImages = ["ac_1", "ac_2", "ac_3", "ac_4", "ac_5", "ac_6", "ac_7", "ac_8", "ac_9", "ac_10", "ac_11", "ac_12", "ac_13", "ac_14", "ac_15" , "ac_16", "ac_17", "ac_18", "ac_19", "ac_20"]
    
    static let categoryType = ["income", "expense"]

    static let defaultCategory = ["Food"        : "cart.fill",
                                  "Restaurants" : "takeoutbag.and.cup.and.straw.fill",
                                  "Clothes"     : "tshirt.fill",
                                  "Leisure"     : "gamecontroller.fill",
                                  "Pets"        : "pawprint.fill",
                                  "Petrol"      : "fuelpump.fill",
                                  "House"       : "house.fill",
                                  "Service"     : "bolt.car.fill",
                                  "Mobile"      : "iphone.homebutton",
                                  "Travel"      : "briefcase.fill",
                                  "Internet"    : "network"]
    
    static let incomeCategories = [
        "Grants" : "35",
        "Refund" : "5",
        "Salary" : "56",
        "Award"  : "6",
        "Lottery": "11",
        "Rental" : "17"
    ]
    
    static let expenseCategories = [
        "Clothe"            : "24",
        "Tax"               : "7",
        "Social"            : "31",
        "Beauty"            : "8",
        "Electronics"       : "42",
        "Food"              : "36",
        "Transportation"    : "40",
        "Sport"             : "1",
        "Shopping"          : "46",
        "Insurance"         : "59",
        "Health"            : "10",
        "Car"               : "20"

    ]
    
    static let accounts = [
        "Cash"          : "ac_2",
        "Credit Card"   : "ac_3",
        "Saving"        : "ac_20"
    ]
}


enum Images {
    
}


enum SFSymbol {
    static let floatingPlus = UIImage(systemName: "plus",withConfiguration: UIImage.SymbolConfiguration(pointSize: 30,weight: .medium))
    
    static let deleteAction = UIImage(systemName: "trash",withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .regular))
    
    static let editAction   = UIImage(systemName: "square.and.pencil",withConfiguration: UIImage.SymbolConfiguration(pointSize: 18,weight: .regular))
    
    static let fromAccount  = UIImage(systemName: "creditcard.fill")
    static let toCategory   = UIImage(systemName: "tag.fill")
    static let setting      = UIImage(systemName: "gear")
}

enum Color {
    
    // System Color
    static let lightGray    = UIColor.lightGray
    static let clear        = UIColor.clear
    static let systemWhite  = UIColor.white
    static let systemBlack  = UIColor.black
    static let systemCyan   = UIColor.systemCyan
    
    // Custom Color
    static let primary = UIColor(named: "ColorPrimary")!
    static let primaryBackground = UIColor(named: "ColorPrimaryBackground")!
    static let textPrimary  = UIColor(named: "ColorTextPrimary")
    static let background   = UIColor(named: "ColorBackground")
    static let surface = UIColor(named: "ColorSurface")!
    static let surfaceLight = UIColor(named: "ColorSurfaceLight")!
    static let border = UIColor(named: "ColorBorder")!
    static let white = UIColor(named: "white")!
    static let blue = UIColor(named: "blue")!
    static let gray = UIColor(named: "gray")!
    static let green = UIColor(named: "green")!
    static let red = UIColor(named: "red")!
    static let mainBlack = UIColor(named: "mainBlack")!
    static let yellow = UIColor(named: "yellow")!
    static let pink = UIColor(named: "pink")!
    static let purple = UIColor(named: "purple")!
    
    static var gradientBackground: [CGColor] {
        if #available(iOS 13.0, *) {
            return [UIColor.systemGray4.cgColor, UIColor.systemGray5.cgColor, UIColor.systemGray5.cgColor]
        } else {
            return [UIColor(hexValue: 0xDADADE).cgColor, UIColor(hexValue: 0xEAEAEE).cgColor, UIColor(hexValue: 0xDADADE).cgColor]
        }
    }

    static var separator: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.systemGray3
        } else {
            return UIColor(hexValue: 0xD1D1D6)
        }
    }

    static var text: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.label
        } else {
            return UIColor(hexValue: 0x3993F8)
        }
    }

    static var accent: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.systemBlue
        } else {
            return UIColor(hexValue: 0x3993F8)
        }
    }
}
