/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 3
  Author: Do Phan Nhat Anh
  ID: s3915034
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

import SwiftUI
import Combine

class MedicineDetailViewModel: ObservableObject {
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
