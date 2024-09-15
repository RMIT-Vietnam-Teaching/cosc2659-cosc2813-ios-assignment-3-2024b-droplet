//
//  AddMedicineViewModel.swift
//  pharmacist_project
//
//  Created by Dinh Le Hong Tin on 15/9/24.
//

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
