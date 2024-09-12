//
//  ProductDetailViewModel.swift
//  pharmacist_project
//
//  Created by Leon Do on 11/9/24.
//

import SwiftUI
import Combine

class ProductDetailViewModel: ObservableObject {
    @Published var medicine: Medicine
    @Published var pharmacy: Pharmacy?
    @Published var similarProducts: [Medicine] = []

    init(medicine: Medicine) {
        self.medicine = medicine
        fetchPharmacyDetails()
        fetchSimilarProducts()
    }
    
    func fetchPharmacyDetails() {
        Task {
            if let pharmacyId = medicine.pharmacyId {
                do {
                    let fetchedPharmacy = try await PharmacyService.shared.getDocument(pharmacyId)
                    DispatchQueue.main.async {
                        self.pharmacy = fetchedPharmacy
                    }
                } catch {
                    print("Error fetching pharmacy details: \(error)")
                }
            }
        }
    }

    func fetchSimilarProducts() {
        Task {
            if let category = medicine.category {
                do {
                    let allMedicines = try await MedicineService.shared.getAllDocuments()
                    DispatchQueue.main.async {
                        self.similarProducts = allMedicines
                            .filter { $0.category == category && $0.id != self.medicine.id }
                    }
                } catch {
                    print("Error fetching similar products: \(error)")
                }
            }
        }
    }
}
