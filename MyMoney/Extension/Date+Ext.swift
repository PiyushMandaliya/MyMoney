//
//  Date+Ext.swift
//  MyMoney
//
//  Created by Piyush Mandaliya on 2022-05-31.
//

import Foundation

extension Date {

    func convertDateInDisplayFormat() -> String {
        return DateFormatter.localizedString(from: self, dateStyle: .medium, timeStyle: .short)
    }
    
}
