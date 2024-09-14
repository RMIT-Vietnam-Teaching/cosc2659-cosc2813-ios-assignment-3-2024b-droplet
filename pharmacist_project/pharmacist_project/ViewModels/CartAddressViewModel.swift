//
//  CartAddressViewModel.swift
//  pharmacist_project
//
//  Created by Dinh Le Hong Tin on 14/9/24.
//

import Foundation
import SwiftUI

class CartAddressViewModel: ObservableObject {
    lazy var paymentViewModel = StripePaymentViewModel(actionSuccess: self.paymentSuccessCallback, actionFailed: self.paymentFailedCallback)
    @State var curUser: AppUser? = nil
    @Published var fullName: String = ""
    @Published var phoneNumber: String = ""
    @Published var address: String = ""
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    func loadUserData() async {
        Task {
            if let user = await AuthenticationService.shared.getAuthenticatedUser() {
                DispatchQueue.main.async {
                    self.curUser = user
                    self.fullName = user.name ?? ""
                    self.phoneNumber = user.phoneNumber ?? ""
                    self.address = user.address ?? ""
                }
            }
        }
    }
    
    func saveAddressAndProceed(payableAmount: Double, paymentMethod: PaymentMethod, shippingMethod: ShippingMethod) async throws {
        guard !fullName.isEmpty, !phoneNumber.isEmpty, !address.isEmpty else {
            showAlert(message: "Please fill in all required fields.")
            return
        }
        
        Task {
            do {
//                try await self.updateDeliveryInfo(
//                    fullName: fullName,
//                    phoneNumber: phoneNumber,
//                    address: address
//                )
                self.callStripePaymentSheet(amount: payableAmount)
            } catch {
                showAlert(message: "Failed to save address: \(error.localizedDescription)")
            }
        }
    }
    
    func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
    
    func updateDeliveryInfo(fullName: String, phoneNumber: String, address: String) async throws {
        guard let userId = AuthenticationService.shared.getAuthenticatedUserOffline()?.id else {
            throw NSError(domain: "Authentication", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        
        do {
            try await UserService.shared.updateDocumentFields(userId: userId, fields: [
                "name": fullName,
                "phoneNumber": phoneNumber,
                "address": address,
            ])
            
            // You might want to update the local user object as well
            if var user = await AuthenticationService.shared.getAuthenticatedUser() {
                user.name = fullName
                user.phoneNumber = phoneNumber
                user.address = address
                // Note: We're not updating the user type here as it's not typically changed during address update
            }
        } catch {
            throw error
        }
    }
    
    func paymentSuccessCallback() {
        print("abc")
    }
    
    func paymentFailedCallback() {
        print("dsaf")
    }
    
    func callStripePaymentSheet(amount: Double) {
        Task {
            paymentViewModel.initiatePayment(amount: amount)
        }
    }
}

