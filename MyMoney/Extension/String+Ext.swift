//
//  String+Ext.swift
//  MyMoney
//
//  Created by Piyush Mandaliya on 2022-06-07.
//

import Foundation

extension String {
    
    func convertStringInDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return dateFormatter.date(from: self)
    }
}
