//
//  BusinessError.swift
//  pharmacist_project
//
//  Created by Thinh Ngo on 7/9/24.
//

import Foundation

enum BussinessError: Error {
    case notEnoughQuantity(String)
    case existMoreThanOneCart(String)
    case cartArrayAndMedicineArrayIsNotSizeEqual
    case cartArrayAndMedicineArrayMismatched
}
