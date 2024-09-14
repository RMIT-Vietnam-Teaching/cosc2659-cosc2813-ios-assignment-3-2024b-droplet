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
                try await calculateTotals()
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
            try await calculateTotals()
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
    }
    
    @MainActor
    public func calculateTotals() async throws {
        var priceInfo = try await OrderService.shared.getCurrentShoppingCartPriceInformation(
            cartItems: self.cartItems, shippingMethod: self.selectedShippingMethod
        )
        
//        var newTotalMRP: Double = 0
//        var newTotalDiscount: Double = 0
//        var newPayableAmount: Double = 0
//
//        for item in cartItems {
//            do {
//                let medicine = try await medicineService.getDocument(item.medicineId)
//                if let quantity = item.quantity {
//                    newTotalMRP += (medicine.price ?? 0) * Double(quantity)
//                    newTotalDiscount += ((medicine.price ?? 0) - (medicine.priceDiscount ?? 0)) * Double(quantity)
//                    newPayableAmount += (medicine.priceDiscount ?? medicine.price ?? 0) * Double(quantity)
//                }
//            } catch {
//                self.error = error
//            }
//        }
//        newPayableAmount += selectedShippingMethod.fee
//
//        // Update the published properties
//        self.totalMRP = newTotalMRP
//        self.totalDiscount = newTotalDiscount
//        self.payableAmount = newPayableAmount
        
        self.totalMRP = priceInfo.totalProductFee
        self.totalDiscount = priceInfo.totalDiscount
        self.payableAmount = priceInfo.totalPayable
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
    
    func updateDeliveryInfo(fullName: String, phoneNumber: String, address: String, addressType: String) async throws {
        guard let userId = AuthenticationService.shared.getAuthenticatedUserOffline()?.id else {
            throw NSError(domain: "Authentication", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        
        do {
            try await UserService.shared.updateDocumentFields(userId: userId, fields: [
                "name": fullName,
                "phoneNumber": phoneNumber,
                "address": address,
                "addressType": addressType
            ])
            
            if var user = await AuthenticationService.shared.getAuthenticatedUser() {
                user.name = fullName
                user.phoneNumber = phoneNumber
                user.address = address
            }
        } catch {
            throw error
        }
    }
    
    func removeCartItem(_ item: CartItem) async {
                isLoading = true
                do {
                    try await cartItemService.deleteDocument(item)
                    cartItems.removeAll { $0.id == item.id }
                    
                    try await calculateTotals()
                } catch {
                    self.error = error
                }
                isLoading = false
            }
}
