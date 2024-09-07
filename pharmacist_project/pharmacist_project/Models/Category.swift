//
//  Category.swift
//  pharmacist_project
//
//  Created by Thinh Ngo on 7/9/24.
//

import Foundation

struct Category: FirebaseModel {
    let id: String
    var name: String?
    
    init(
        id: String,
        name: String? = nil
    ) {
        self.id = id
        self.name = name
    }
    
    init(
        name: String? = nil
    ) {
        self.id = CRUDService<Category>.generateUniqueId(collection: CategoryService.shared.collection)
        self.name = name
    }
}
