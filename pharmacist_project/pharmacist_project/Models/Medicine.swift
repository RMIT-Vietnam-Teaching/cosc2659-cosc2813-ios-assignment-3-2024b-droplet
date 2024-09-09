//
//  Medicine.swift
//  pharmacist_project
//
//  Created by Long Pham Hoang on 6/9/24.
//

import Foundation

enum Category: String, Codable {
    case vitamin
    case calcium
    case mineral
    case probiotic
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
