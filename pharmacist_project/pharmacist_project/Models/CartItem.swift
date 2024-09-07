//
//  Medicine.swift
//  pharmacist_project
//
//  Created by Leon Do on 6/9/24.
//

import Foundation

struct CartItem: FirebaseModel {
    let id: String
    let cartId: String
    let medicineId: String
    var quantity: Int
    var pricePerUnit: Double
    var pricePerUnitDiscount: Double?
    
    func imageStr() async throws -> String  {
        return try await MedicineService.shared.getDocument(medicineId).images.first ?? GlobalUtils.getNoImageImageString()
    }
    
    func getMedicine() async throws -> Medicine {
        return try await MedicineService.shared.getDocument(medicineId)
    }
    
    mutating func increaseQuantity() {
        self.quantity += 1
    }

    @discardableResult
    mutating func decreaseQuantity() -> Bool {
        if self.quantity > 1 {
            self.quantity -= 1
            return false
        } else {
            self.quantity = 0
            return true
        }
    }
    
    init(
        id: String,
        cartId: String,
        medicineId: String,
        quantity: Int = 0,
        pricePerUnit: Double = 0,
        pricePerUnitDiscount: Double? = nil)
    {
        self.id = id
        self.cartId = cartId
        self.medicineId = medicineId
        self.quantity = quantity
        self.pricePerUnit = pricePerUnit
        self.pricePerUnitDiscount = pricePerUnitDiscount
    }
    
    init(
        cartId: String,
        medicineId: String,
        quantity: Int = 0,
        pricePerUnit: Double = 0,
        pricePerUnitDiscount: Double? = nil)
    {
        self.id = CRUDService<CartItem>.generateUniqueId(collection: CartService.shared.collection)
        self.cartId = cartId
        self.medicineId = medicineId
        self.quantity = quantity
        self.pricePerUnit = pricePerUnit
        self.pricePerUnitDiscount = pricePerUnitDiscount
    }
}
