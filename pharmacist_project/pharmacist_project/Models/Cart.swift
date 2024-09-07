//
//  Cart.swift
//  pharmacist_project
//
//  Created by Thinh Ngo on 7/9/24.
//

import Foundation

struct Cart: FirebaseModel {
    let id: String
    let userId: String
    
    init(id: String, userId: String) {
        self.id = id
        self.userId = userId
    }
    
    init(userId: String) {
        self.id = CRUDService<Cart>.generateUniqueId(collection: CartService.shared.collection)
        self.userId = userId
    }
}
