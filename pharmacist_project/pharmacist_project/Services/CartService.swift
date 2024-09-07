//
//  CartService.swift
//  pharmacist_project
//
//  Created by Thinh Ngo on 7/9/24.
//

import Foundation

final class CartService: CRUDService<Cart> {
    static let shared = CartService()
    
    override var collectionName: String {"carts"}
    
    func createEmptyCart(for userId: String) async throws {
        let newCart = Cart(userId: userId)
        try await self.createDocument(newCart)
    }
    
    func hasCartItemWith(medicineId: String) async throws -> Bool {
        let cartItems = try await CartItemService.shared.fetchDocuments(filter: { query in
            query.whereField("medicineId", isEqualTo: medicineId)
        })
        
        return !cartItems.isEmpty
    }
    
    func addNewCartItem(cart: Cart, medicine: Medicine, quantity: Int) async throws {
        let newCartItem = CartItem(cartId: cart.id,
                                   medicineId: medicine.id,
                                   quantity: 1,
                                   createDate: Date())
        try await CartItemService.shared.createDocument(newCartItem)
    }
    
    func getUserCart(userId: String) async throws -> Cart {
        let carts = try await self.fetchDocuments(filter: { query in
            query.whereField("userId", isEqualTo: userId)
        })
        if carts.count != 1 {
            fatalError("User have more or less than one shopping cart")
        }
        return carts[0]
    }
}
