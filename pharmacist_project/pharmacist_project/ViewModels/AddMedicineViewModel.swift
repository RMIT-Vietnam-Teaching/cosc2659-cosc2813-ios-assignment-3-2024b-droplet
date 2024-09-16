/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 3
  Author: Dinh Le Hong Tin
  ID: s3932134
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

import Foundation

import Foundation

class AddMedicineViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var price: Double = 0.0
    @Published var priceDiscount: Double = 0.0
    @Published var availableQuantity: Int = 0
    @Published var description: String = ""
    @Published var ingredients: String = ""
    @Published var supplement: String = ""
    @Published var note: String = ""
    @Published var sideEffect: String = ""
    @Published var dosage: String = ""
    @Published var supplier: String = ""
    @Published var images: [String] = [""]
    @Published var category: Category = .vitamin
    
    var isValid: Bool {
        !name.isEmpty &&
        price > 0 &&
        priceDiscount >= 0 &&
        availableQuantity >= 0 &&
        !description.isEmpty &&
        !ingredients.isEmpty &&
        !dosage.isEmpty &&
        !supplier.isEmpty &&
        !images.filter { !$0.isEmpty }.isEmpty
    }
    
    func addImage() {
        guard images.count < 5 else { return }
        images.append("")
    }
    
    func saveMedicine() async {
        let newMedicine = Medicine(
            name: name,
            price: price,
            priceDiscount: priceDiscount,
            availableQuantity: availableQuantity,
            description: description,
            ingredients: ingredients,
            supplement: supplement,
            note: note,
            sideEffect: sideEffect,
            dosage: dosage,
            supplier: supplier,
            images: images.filter { !$0.isEmpty },
            category: category,
            pharmacyId: nil,
            createdDate: Date()
        )
        
        do {
            try await MedicineService.shared.createDocument(newMedicine)
            print("Medicine saved successfully")
        } catch {
            print("Error saving medicine: \(error.localizedDescription)")
        }
    }
}
