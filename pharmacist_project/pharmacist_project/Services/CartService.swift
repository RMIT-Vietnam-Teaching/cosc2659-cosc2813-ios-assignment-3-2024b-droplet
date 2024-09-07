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
}
