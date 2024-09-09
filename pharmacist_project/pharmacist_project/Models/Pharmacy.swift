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
    var description: String?
    var createdDate: Date?
    
    init(id: String, name: String?, address: String?, description: String?, createdDate: Date?) {
        self.id = id
        self.name = name
        self.address = address
        self.description = description
        self.createdDate = createdDate
    }
    
    init(name: String?, address: String?, description: String?, createdDate: Date?) {
        self.id = CRUDService<Pharmacy>.generateUniqueId(collection: PharmacyService.shared.collection)
        self.name = name
        self.address = address
        self.description = description
        self.createdDate = createdDate
    }
}
