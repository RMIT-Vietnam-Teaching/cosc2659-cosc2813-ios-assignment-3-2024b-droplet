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
        let discount = (1 - self / priceDiscount) * 100
        return Int(discount)
    }
}
