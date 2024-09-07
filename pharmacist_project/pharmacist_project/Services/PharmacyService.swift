//
//  PharmacyService.swift
//  pharmacist_project
//
//  Created by Thinh Ngo on 7/9/24.
//

import Foundation

final class PharmacyService: CRUDService<Pharmacy> {
    static let shared = PharmacyService()
    
    override var collectionName: String {"pharmacies"}
}
