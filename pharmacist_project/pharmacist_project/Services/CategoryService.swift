//
//  CategoryService.swift
//  pharmacist_project
//
//  Created by Thinh Ngo on 7/9/24.
//

import Foundation

final class CategoryService: CRUDService<Category> {
    static let shared = CategoryService()
    
    override var collectionName: String {"categories"}
}
