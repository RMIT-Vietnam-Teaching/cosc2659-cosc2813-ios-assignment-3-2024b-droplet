//
//  CartAddressViewModel.swift
//  pharmacist_project
//
//  Created by Dinh Le Hong Tin on 14/9/24.
//

import Foundation
import SwiftUI

class CartAddressViewModel: ObservableObject {
    var payableAmount: Double
    var paymentMethod: PaymentMethod
    var shippingMethod: ShippingMethod
    
    @State var curUser: AppUser? = nil
    @Published var fullName: String = ""
    @Published var phoneNumber: String = ""
    @Published var address: String = ""
    @Published var note: String = ""
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var isProcessingPayment = false

    private var orderService = OrderService.shared
    
    lazy var paymentViewModel: StripePaymentViewModel = {
        StripePaymentViewModel(
            actionSuccess: { [weak self] in
                self?.paymentSuccessCallback()
            },
            actionFailed: { [weak self] error in
                self?.paymentFailedCallback(error: error!)
            }
        )
    }()

    init(payableAmount: Double, paymentMethod: PaymentMethod, shippingMethod: ShippingMethod) {
        self.payableAmount = payableAmount
        self.paymentMethod = paymentMethod
        self.shippingMethod = shippingMethod
    }

    func loadUserData() async {
        if let user = await AuthenticationService.shared.getAuthenticatedUser() {
            DispatchQueue.main.async {
                self.curUser = user
                self.fullName = user.name ?? ""
                self.phoneNumber = user.phoneNumber ?? ""
                self.address = user.address ?? ""
            }
        }
    }

    func proceedToPayment() async throws {
        guard !fullName.isEmpty, !phoneNumber.isEmpty, !address.isEmpty else {
            showAlert(message: "Please fill in all required fields.")
            return
        }

        isProcessingPayment = true
        
        Task {
            do {
                try await self.callStripePaymentSheet(amount: payableAmount)
            } catch {
                isProcessingPayment = false
                showAlert(message: "Payment failed: \(error.localizedDescription)")
                return
            }
        }
    }

    func callStripePaymentSheet(amount: Double) async throws {
        paymentViewModel.initiatePayment(amount: amount)
    }

    func paymentSuccessCallback() {
        Task {
            guard let user = curUser else { return }
            do {
                let _ = try await orderService.placeOrder(
                    userId: user.id,
                    fullName: fullName,
                    phoneNumber: phoneNumber,
                    address: address,
                    note: note,
                    paymentMethod: paymentMethod,
                    shippingMethod: shippingMethod
                )
                DispatchQueue.main.async {
                    self.isProcessingPayment = false
                    self.showAlert(message: "Order place")
                    print("Order placed successfully")
                }
            } catch {
                DispatchQueue.main.async {
                    self.isProcessingPayment = false
                    self.showAlert(message: "Failed to place the order: \(error.localizedDescription)")
                }
            }
        }
    }

    func paymentFailedCallback(error: Error) {
        DispatchQueue.main.async {
            self.isProcessingPayment = false
            self.showAlert(message: "\(error.localizedDescription)")
        }
    }

    func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
}
