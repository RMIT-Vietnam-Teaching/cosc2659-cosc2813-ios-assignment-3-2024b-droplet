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
    var quantity: Int?
    var createdDate: Date?
    
    func imageStr() async throws -> String  {
        return try await MedicineService.shared.getDocument(medicineId).images.first ?? GlobalUtils.getNoImageImageString()
    }
    
    func getMedicine() async throws -> Medicine {
        return try await MedicineService.shared.getDocument(medicineId)
    }
    
    mutating func increaseQuantity() {
        if self.quantity != nil {
            self.quantity! = self.quantity! + 1
        }
    }

    @discardableResult
    mutating func decreaseQuantity() -> Bool {
        if self.quantity != nil {
            if self.quantity! >= 2 {
                self.quantity! = self.quantity! - 1
                return false
            } else {
                self.quantity = 1
                return true
            }
        }
        return false
    }
    
    init(
        id: String,
        cartId: String,
        medicineId: String,
        quantity: Int?,
        createdDate: Date?
    ) {
        self.id = id
        self.cartId = cartId
        self.medicineId = medicineId
        self.quantity = quantity
        self.createdDate = createdDate
    }
    
    init(
        cartId: String,
        medicineId: String,
        quantity: Int?,
        createdDate: Date?
    ) {
        self.id = CRUDService<CartItem>.generateUniqueId(collection: CartService.shared.collection)
        self.cartId = cartId
        self.medicineId = medicineId
        self.quantity = quantity
        self.createdDate = createdDate
    }
}
