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
    
    func increaseQuantity() async {
        if self.cartItem != nil {
            do {
                self.cartItem = try await CartItemService.shared.increaseQuantity(cartItemId: self.cartItem!.id)
            } catch {
                print("increase error \(error)")
            }
        }
    }
    
    func decreaseQuantity() async {
        if self.cartItem != nil {
            do {
                self.cartItem = try await CartItemService.shared.decreaseQuantity(cartItemId: self.cartItem!.id)
            } catch {
                print("decrease error \(error)")
            }
        }
    }
}
