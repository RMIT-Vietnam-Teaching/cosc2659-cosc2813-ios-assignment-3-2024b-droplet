//
//  MedicineService.swift
//  pharmacist_project
//
//  Created by Thinh Ngo on 7/9/24.
//

import Foundation

final class MedicineService: CRUDService<Medicine> {
    static let shared = MedicineService()
    
    override var collectionName: String {"medicines"}
}
