//
//  Double+Ext.swift
//  MyMoney
//
//  Created by Piyush Mandaliya on 2022-05-30.
//

extension Double {
    
    var decimalPlaces: Int {
        let decimals    = String(self).split(separator: ".")[1]
        return decimals == "0" ? 0 : decimals.count
    }
    
    
    func toString() -> String {
        return String(format: "%.1f",self)
    }
}
