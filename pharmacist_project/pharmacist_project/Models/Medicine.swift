/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 3
  Author: Long Hoang Pham
  ID: s3938007
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

enum Category: String, Codable, CaseIterable {
    case vitamin
    case calcium
    case mineral
    case probiotic
    case cardiovascular
    // ...
}

struct Medicine: FirebaseModel {
    let id: String
    var name: String?
    var price: Double?
    var priceDiscount: Double?
    var availableQuantity: Int?
    var description: String?
    var ingredients: String?
    var supplement: String?
    var note: String?
    var sideEffect: String?
    var dosage: String?
    var supplier: String?
    var images: [String]
    var category: Category?
    let pharmacyId: String?
    var createdDate: Date?
    
    func getRepresentImageStr() -> String {
        return images.first ?? GlobalUtils.getNoImageImageString()
    }
    
    init(
        id: String,
        name: String? = nil,
        price: Double? = nil,
        priceDiscount: Double? = nil,
        availableQuantity: Int? = nil,
        description: String? = nil,
        ingredients: String? = nil,
        supplement: String? = nil,
        note: String? = nil,
        sideEffect: String? = nil,
        dosage: String? = nil,
        supplier: String? = nil,
        images: [String],
        category: Category?,
        pharmacyId: String?,
        createdDate: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.price = price
        self.priceDiscount = priceDiscount
        self.availableQuantity = availableQuantity
        self.description = description
        self.ingredients = ingredients
        self.supplement = supplement
        self.note = note
        self.sideEffect = sideEffect
        self.dosage = dosage
        self.supplier = supplier
        self.images = images
        self.category = category
        self.pharmacyId = pharmacyId
        self.createdDate = createdDate
    }
    
    init(
        name: String? = nil,
        price: Double? = nil,
        priceDiscount: Double? = nil,
        availableQuantity: Int? = nil,
        description: String? = nil,
        ingredients: String? = nil,
        supplement: String? = nil,
        note: String? = nil,
        sideEffect: String? = nil,
        dosage: String? = nil,
        supplier: String? = nil,
        images: [String],
        category: Category?,
        pharmacyId: String?,
        createdDate: Date? = nil
    ) {
        self.id = CRUDService<Medicine>.generateUniqueId(collection: MedicineService.shared.collection)
        self.name = name
        self.price = price
        self.priceDiscount = priceDiscount
        self.availableQuantity = availableQuantity
        self.description = description
        self.ingredients = ingredients
        self.supplement = supplement
        self.note = note
        self.sideEffect = sideEffect
        self.dosage = dosage
        self.supplier = supplier
        self.images = images
        self.category = category
        self.pharmacyId = pharmacyId
        self.createdDate = createdDate
    }
}
