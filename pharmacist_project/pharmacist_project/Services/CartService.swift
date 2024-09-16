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

final class CartService: CRUDService<Cart> {
    static let shared = CartService()
    
    override var collectionName: String {"carts"}
    
    func createEmptyCart(for userId: String) async throws {
        let newCart = Cart(userId: userId)
        try await self.createDocument(newCart)
    }
    
    func addNewOrIncreaseCartItem(medicineId: String, userId: String) async throws -> CartItem? {
        let userCart = try await CartService.shared.getUserCart(userId: userId)
        
        let existedCartItem = try await self.getCartItemWith(medicineId: medicineId, cartId: userCart.id)
        if existedCartItem != nil {
            return try await CartItemService.shared.increaseQuantity(cartItemId: existedCartItem!.id)
        } else {
            return try await self.addNewCartItem(cartId: userCart.id, medicineId: medicineId)
        }
    }
    
    func getCartItemWith(medicineId: String, cartId: String) async throws -> CartItem? {
        let cartItems = try await CartItemService.shared.fetchDocuments(filter: { query in
            query.whereField("medicineId", isEqualTo: medicineId)
                .whereField("cartId", isEqualTo: cartId)
        })
        
        if cartItems.isEmpty {
            return nil
        }
        
        return cartItems[0]
    }
    
    func hasCartItemWith(medicineId: String) async throws -> Bool {
        let cartItems = try await CartItemService.shared.fetchDocuments(filter: { query in
            query.whereField("medicineId", isEqualTo: medicineId)
        })
        
        return !cartItems.isEmpty
    }
    
    func addNewCartItem(cartId: String, medicineId: String) async throws -> CartItem? {
        // check medicine quant
        let medicineDB = try await MedicineService.shared.getDocument(medicineId)
        guard medicineDB.availableQuantity != nil && medicineDB.availableQuantity != nil && medicineDB.availableQuantity! > 1 else {
            throw BussinessError.notEnoughQuantity("Not enough medicine quantity to create new cart item \(medicineDB.name ?? "")")
        }
        
        let newCartItem = CartItem(cartId: cartId,
                                   medicineId: medicineId,
                                   quantity: 1,
                                   createdDate: Date())
        try await CartItemService.shared.createDocument(newCartItem)
        return try await CartItemService.shared.getDocument(newCartItem.id)
    }
    
    func getUserCart(userId: String) async throws -> Cart {
        let carts = try await self.fetchDocuments(filter: { query in
            query.whereField("userId", isEqualTo: userId)
        })
        if carts.count != 1 {
            throw BussinessError.existMoreThanOneCart("User has more or less than one shopping cart")
        }
        return carts[0]
    }
}
