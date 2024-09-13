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
    @Published var cartItem: CartItem? = nil
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    
    private let medicineId: String
    
    init(medicineId: String) {
        self.medicineId = medicineId
    }
    
    func loadMedicine() async {
        isLoading = true
        do {
            medicine = try await MedicineService.shared.getDocument(medicineId)
            medicineName = medicine?.name ?? ""
            representImage = medicine?.getRepresentImageStr() ?? GlobalUtils.getLoadingImageString()
        } catch {
            errorMessage = "Failed to load medicine: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
//    func addToCart() async {
//        isLoading = true
//        do {
//            guard let medicine = medicine else {
//                throw NSError(domain: "CartItemViewModel", code: 0, userInfo: [NSLocalizedDescriptionKey: "Medicine not loaded"])
//            }
//            let newCartItem = CartItem(cartId: UUID().uuidString, medicineId: medicineId, quantity: 1, createdDate: Date())
//            try await CartItemService.shared.createDocument(newCartItem)
//            self.cartItem = newCartItem
//        } catch {
//            errorMessage = "Failed to add to cart: \(error.localizedDescription)"
//        }
//        isLoading = false
//    }
    
    func increaseQuantity() async {
        guard let cartItem = cartItem else { return }
        isLoading = true
        do {
            self.cartItem = try await CartItemService.shared.increaseQuantity(cartItemId: cartItem.id)
        } catch {
            errorMessage = "Failed to increase quantity: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    func decreaseQuantity() async {
        guard let cartItem = cartItem else { return }
        isLoading = true
        do {
            self.cartItem = try await CartItemService.shared.decreaseQuantity(cartItemId: cartItem.id)
        } catch {
            errorMessage = "Failed to decrease quantity: \(error.localizedDescription)"
        }
        isLoading = false
    }
}
