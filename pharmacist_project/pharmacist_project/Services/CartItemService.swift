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
}
