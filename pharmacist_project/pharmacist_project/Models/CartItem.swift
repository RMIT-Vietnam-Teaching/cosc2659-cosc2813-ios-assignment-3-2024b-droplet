/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 3
  Author: Do Phan Nhat Anh
  ID: s3915034
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
