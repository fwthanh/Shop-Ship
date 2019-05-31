//
//  DoubleExtensions.swift
//  App
//
//  Created by Pqt Dark on 4/20/19.
//  Copyright © 2019 Pqt. All rights reserved.
//

import Foundation

public extension Double {
    
    /// e.g 1234.567 -> "$1,234.57", 1234.00 -> "$1,234.00"
    var _usCurrencyString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "en-US")
        return formatter.string(from: NSNumber(value: self))!
    }

    func _usCurrencyStringWith(maxFractionDigits: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = maxFractionDigits
        formatter.locale = Locale(identifier: "en-US")
        return formatter.string(from: NSNumber(value: self))!
    }

    var _localeCurrencyString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale.current
        return formatter.string(from: NSNumber(value: self))!
    }
    
    var _vnCurrencyString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "vi_VN")
        return formatter.string(from: NSNumber(value: self))!
    }
}

extension Double {
    
    func _isLess(than other: Double) -> Bool {
        return self.isLess(than: other)
    }
    
    func _isLessThanOrEqualTo(_ other: Double) -> Bool {
        return self.isLessThanOrEqualTo(other)
    }
    
    func _isGreater(than other: Double) -> Bool {
        return !self.isLessThanOrEqualTo(other)
    }
}

extension String {
    var _currencyDouble: Double {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.locale = NSLocale(localeIdentifier: "vi_VN") as Locale
        //let numberFromField = (NSString(string: self).doubleValue)
        //return formatter.string(from: NSNumber(value: numberFromField)) ?? ""
        if let number = formatter.number(from: self) {
            let amount = number.doubleValue
            return amount
        }
        return 0.0
    }
}
