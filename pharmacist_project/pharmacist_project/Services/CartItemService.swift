//
//  CartItemService.swift
//  pharmacist_project
//
//  Created by Thinh Ngo on 7/9/24.
//

import Foundation

final class CartItemService: CRUDService<CartItem> {
    static let shared = CartItemService()
    
    override var collectionName: String {"cartItems"}
    
    func getUserCartItemsFromCartId(cartId: String) async throws -> [CartItem] {
        let cartItems = try await self.fetchDocuments(filter: { query in
            query.whereField("cartId", isEqualTo: cartId)
        })
        return cartItems
    }
    
    func getUserCartItems(userId: String) async throws -> [CartItem] {
        let cart = try await CartService.shared.getUserCart(userId: userId)
        let cartItems = try await self.fetchDocuments(filter: { query in
            query.whereField("cartId", isEqualTo: cart.id)
        })
        return cartItems
    }
    
    
}
