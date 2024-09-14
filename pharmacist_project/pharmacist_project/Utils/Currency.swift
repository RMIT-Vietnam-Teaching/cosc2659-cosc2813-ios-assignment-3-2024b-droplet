//
//  CurrencyFormatter.swift
//  pharmacist_project
//
//  Created by Long Pham Hoang on 6/9/24.
//

import Foundation

extension Double {
    func formatAsCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "VND"
        formatter.maximumFractionDigits = 0 // No decimals for VND
        formatter.currencySymbol = "₫" // Vietnamese Dong symbol
        return formatter.string(from: NSNumber(value: self)) ?? "₫\(self)"
    }
    
    func calculateDiscountPercentage(priceDiscount: Double) -> Int {
        guard priceDiscount != 0.0 else {
            return 100
        }
        
        guard self != 0.0 else {
            return 100
        }
        
        guard self >= priceDiscount else {
            return 100
        }
        
        let discount = (self - priceDiscount) / self * 100
        return Int(discount)
    }
}
