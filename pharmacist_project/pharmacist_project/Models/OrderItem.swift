//
//  OrderItem.swift
//  pharmacist_project
//
//  Created by Thinh Ngo on 7/9/24.
//

import Foundation

struct OrderItem: FirebaseModel {
    let id: String
    let orderId: String
    let medicineId: String
    var quantity: Int?
    var pricePerUnit: Double?
    var pricePerUnitDiscount: Double?
    
    init(
        id: String,
        orderId: String,
        medicineId: String,
        quantity: Int? = nil,
        pricePerUnit: Double? = nil,
        pricePerUnitDiscount: Double? = nil)
    {
        self.id = id
        self.orderId = orderId
        self.medicineId = medicineId
        self.quantity = quantity
        self.pricePerUnit = pricePerUnit
        self.pricePerUnitDiscount = pricePerUnitDiscount
    }
    
    init(
        orderId: String,
        medicineId: String,
        quantity: Int? = nil,
        pricePerUnit: Double? = nil,
        pricePerUnitDiscount: Double? = nil)
    {
        self.id = CRUDService<CartItem>.generateUniqueId(collection: CartService.shared.collection)
        self.orderId = orderId
        self.medicineId = medicineId
        self.quantity = quantity
        self.pricePerUnit = pricePerUnit
        self.pricePerUnitDiscount = pricePerUnitDiscount
    }
}
