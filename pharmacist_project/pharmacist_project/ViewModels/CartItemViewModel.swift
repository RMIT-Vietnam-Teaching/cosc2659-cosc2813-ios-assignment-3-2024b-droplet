//
//  CartItemViewModel.swift
//  pharmacist_project
//
//  Created by Thinh Ngo on 7/9/24.
//

import Foundation

@MainActor
final class CartItemViewModel: ObservableObject {
    @Published var representImage: String = GlobalUtils.getLoadingImageString()
    @Published var medicineName: String = "loading.."
    @Published var medicine: Medicine? = nil
    var cartItem: CartItem? = nil
    
    func setupWith(cartItem: CartItem) {
        self.cartItem = cartItem
    }
    
    func loadMedicine() async throws {
        medicine = try await MedicineService.shared.getDocument(cartItem!.medicineId)
        
        medicineName = medicine!.name ?? ""
        representImage = medicine!.getRepresentImageStr()
    }
}
