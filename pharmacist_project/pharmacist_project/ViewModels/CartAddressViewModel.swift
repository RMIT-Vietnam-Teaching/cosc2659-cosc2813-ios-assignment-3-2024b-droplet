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
import SwiftUI

class CartAddressViewModel: ObservableObject {
    var payableAmount: Double
    var paymentMethod: PaymentMethod
    var shippingMethod: ShippingMethod
    
    var curUser: AppUser? = nil
    @Published var fullName: String = ""
    @Published var phoneNumber: String = ""
    @Published var address: String = ""
    @Published var note: String = ""
    @Published var showAlert = false
    @Published var isError = true
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
        
        if paymentMethod == .visa {
            Task {
                do {
                    try await self.callStripePaymentSheet(amount: payableAmount)
                } catch {
                    isProcessingPayment = false
                    showAlert(message: "Payment failed: \(error.localizedDescription)")
                    return
                }
            }
        } else {
            Task {
                await placeOrder()
            }
        }
    }

    func callStripePaymentSheet(amount: Double) async throws {
        paymentViewModel.initiatePayment(amount: amount)
    }

    // Handles order placement after payment success
    func placeOrder() async {
        do {
            try await orderService.placeOrder(
                userId: curUser!.id,
                fullName: fullName,
                phoneNumber: phoneNumber,
                address: address,
                note: note,
                paymentMethod: paymentMethod,
                shippingMethod: shippingMethod
            )
            DispatchQueue.main.async {
                self.isProcessingPayment = false
                print("Order placed successfully")
                
                self.showAlert(message: "Order Placed", isError: false)
            }
        } catch {
            DispatchQueue.main.async {
                self.isProcessingPayment = false
                self.showAlert(message: "Failed to place the order: \(error.localizedDescription)", isError: true)
            }
        }
    }

    // Payment success callback to navigate to OrderView
    func paymentSuccessCallback() {
        print("Placing order")
        Task {
            await placeOrder()
        }
    }

    func paymentFailedCallback(error: Error) {
        DispatchQueue.main.async {
            self.isProcessingPayment = false
            self.showAlert(message: "Payment failed: \(error.localizedDescription)", isError: true)
        }
    }

    func showAlert(message: String, isError: Bool = true) {
        self.alertMessage = message
        self.isError = isError
        self.showAlert = true
    }
}


