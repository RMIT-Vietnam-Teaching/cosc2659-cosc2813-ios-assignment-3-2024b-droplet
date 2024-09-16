/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 3
  Author: Ngo Ngoc Thinh
  ID: s3879364
  Created  date: 05/09/2024
  Last modified: 16/09/2024
  Acknowledgement:
     https://rmit.instructure.com/courses/138616/modules/items/6274581
     https://rmit.instructure.com/courses/138616/modules/items/6274582
     https://rmit.instructure.com/courses/138616/modules/items/6274583
     https://rmit.instructure.com/courses/138616/modules/items/6274584
     https://rmit.instructure.com/courses/138616/modules/items/6274585
     https://rmit.instructure.com/courses/138616/modules/items/6274586
     https://rmit.instructure.com/courses/138616/modules/items/6274588
     https://rmit.instructure.com/courses/138616/modules/items/6274589
     https://rmit.instructure.com/courses/138616/modules/items/6274590
     https://rmit.instructure.com/courses/138616/modules/items/6274591
     https://rmit.instructure.com/courses/138616/modules/items/6274592
     https://developer.apple.com/documentation/swift/
     https://developer.apple.com/documentation/swiftui/
*/

import Foundation

final class CartItemService: CRUDService<CartItem> {
    static let shared = CartItemService()
    
    override var collectionName: String {"cartItems"}
    
    func getUserCartItemsFromCartId(cartId: String) async throws -> [CartItem] {
        let cartItems = try await self.fetchDocuments(filter: { query in
            query.whereField("cartId", isEqualTo: cartId)
        })
        // sort by new to old (new cart item display first)
        return cartItems.sorted(by: {
            $0.createdDate! < $1.createdDate!
        })
    }
    
    func getUserCartItems(userId: String) async throws -> [CartItem] {
        let cart = try await CartService.shared.getUserCart(userId: userId)
        let cartItems = try await self.fetchDocuments(filter: { query in
            query.whereField("cartId", isEqualTo: cart.id)
        })
        // sort by new to old (new cart item display first)
        return cartItems.sorted(by: {
            $0.createdDate! < $1.createdDate!
        })
    }
    
    func increaseQuantity(cartItemId: String) async throws -> CartItem {
        var cartItem = try await self.getDocument(cartItemId)
        
        // get max quant
        let medicine = try await MedicineService.shared.getDocument(cartItem.medicineId)
        let maxQuant = medicine.availableQuantity
        
        if cartItem.quantity != nil && maxQuant != nil && cartItem.quantity! < maxQuant! {
            cartItem.quantity! += 1
        }
        
        try await self.updateDocument(cartItem)
        return cartItem
    }
    
    func decreaseQuantity(cartItemId: String) async throws -> CartItem {
        var cartItem = try await self.getDocument(cartItemId)

        if cartItem.quantity != nil && cartItem.quantity! >= 1 {
            cartItem.quantity! -= 1
        }
        
        try await self.updateDocument(cartItem)
        return cartItem
    }
}
