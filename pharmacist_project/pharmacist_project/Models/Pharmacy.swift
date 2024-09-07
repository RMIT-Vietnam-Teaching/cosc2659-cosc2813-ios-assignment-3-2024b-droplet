//
//  Pharmacy.swift
//  pharmacist_project
//
//  Created by Thinh Ngo on 7/9/24.
//

import Foundation

struct Pharmacy: FirebaseModel {
    let id: String
    var name: String?
    var address: String?
    
    init(id: String, name: String? = nil, address: String? = nil) {
        self.id = id
        self.name = name
        self.address = address
    }
    
    init(name: String? = nil, address: String? = nil) {
        self.id = CRUDService<Pharmacy>.generateUniqueId(collection: PharmacyService.shared.collection)
        self.name = name
        self.address = address
    }
}
