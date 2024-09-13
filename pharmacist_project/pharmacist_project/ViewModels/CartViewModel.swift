//
//  CartViewModel.swift
//  pharmacist_project
//
//  Created by Dinh Le Hong Tin on 13/9/24.
//

import Foundation

@MainActor
class CartDeliveryViewModel: ObservableObject {
    @Published var cartItems: [CartItem] = []
    @Published var totalMRP: Double = 0
    @Published var totalDiscount: Double = 0
    @Published var payableAmount: Double = 0
    @Published var isLoading: Bool = false
    @Published var error: Error?
    @Published var selectedPaymentMethod: PaymentMethod = .COD
    @Published var selectedShippingMethod: ShippingMethod = .ShopeeExpress {
        didSet {
            Task {
                await calculateTotals()
            }
        }
    }

    private let cartService = CartService.shared
    private let cartItemService = CartItemService.shared
    private let medicineService = MedicineService.shared

    func addToCart(_ item: CartItem) async {
        isLoading = true
        do {
            if let newCartItem = try await cartService.addNewOrIncreaseCartItem(medicineId: item.medicineId, userId: AuthenticationService.shared.getAuthenticatedUser()?.id ?? "") {
                // Handle new cart item if needed
            } else {
                throw NSError(domain: "CartError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to add item to cart"])
            }
        } catch {
            self.error = error
        }
        isLoading = false
    }

    func loadCartItems() async {
        isLoading = true
        do {
            guard let userId = AuthenticationService.shared.getAuthenticatedUserOffline()?.id else {
                throw NSError(domain: "Authentication", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
            }
            let cart = try await cartService.getUserCart(userId: userId)
            cartItems = try await cartItemService.getUserCartItemsFromCartId(cartId: cart.id)
            await calculateTotals()
        } catch {
            self.error = error
        }
        isLoading = false
    }
    
    func updatePaymentMethod(_ method: PaymentMethod) {
        selectedPaymentMethod = method
    }

    func updateShippingMethod(_ method: ShippingMethod) {
        selectedShippingMethod = method
        // No need to call calculateTotals() here, it will be called by the didSet observer
    }
    
    @MainActor
    public func calculateTotals() async {
        var newTotalMRP: Double = 0
        var newTotalDiscount: Double = 0
        var newPayableAmount: Double = 0
        
        for item in cartItems {
            do {
                let medicine = try await medicineService.getDocument(item.medicineId)
                if let quantity = item.quantity {
                    newTotalMRP += (medicine.price ?? 0) * Double(quantity)
                    newTotalDiscount += ((medicine.price ?? 0) - (medicine.priceDiscount ?? 0)) * Double(quantity)
                    newPayableAmount += (medicine.priceDiscount ?? medicine.price ?? 0) * Double(quantity)
                }
            } catch {
                self.error = error
            }
        }
        newPayableAmount += selectedShippingMethod.fee
        
        // Update the published properties
        self.totalMRP = newTotalMRP
        self.totalDiscount = newTotalDiscount
        self.payableAmount = newPayableAmount
    }
    
    func updateCartItemQuantity(_ item: CartItem, increase: Bool) async {
        do {
            if increase {
                _ = try await cartItemService.increaseQuantity(cartItemId: item.id)
            } else {
                _ = try await cartItemService.decreaseQuantity(cartItemId: item.id)
            }
            await loadCartItems()
        } catch {
            self.error = error
        }
    }
}
