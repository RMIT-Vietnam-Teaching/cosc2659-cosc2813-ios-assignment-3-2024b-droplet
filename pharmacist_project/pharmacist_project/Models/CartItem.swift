//
//  Medicine.swift
//  pharmacist_project
//
//  Created by Leon Do on 6/9/24.
//

import Foundation

struct CartItem: Identifiable {
    var id: String
    var userId: String
    var name: String
    var image: String
    var quantity: Int
    var price: Double
    
    mutating func increaseQuantity() {
        self.quantity += 1
    }

    mutating func decreaseQuantity() -> Bool {
        if self.quantity > 1 {
            self.quantity -= 1
            return false
        } else {
            self.quantity = 0
            return true
        }
    }
}
