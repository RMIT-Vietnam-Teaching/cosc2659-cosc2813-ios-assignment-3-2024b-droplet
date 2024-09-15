//
//  StripePaymentViewModel.swift
//  pharmacist_project
//
//  Created by Long Pham Hoang on 13/9/24.
//

import SwiftUI
import Foundation
import FirebaseFunctions
import Stripe
import StripePaymentSheet

class StripePaymentViewModel: ObservableObject {
    @Published var paymentInProgress = false
    @Published var paymentSuccess = false
    @Published var paymentSheet: PaymentSheet?
    lazy var functions = Functions.functions()
    
    var actionSuccess: () -> Void
    var actionFailed: () -> Void
    
    init(actionSuccess: @escaping () -> Void, actionFailed: @escaping () -> Void) {
        self.actionSuccess = actionSuccess
        self.actionFailed  = actionFailed
    }

    
    func initiatePayment(amount: Double) {
        DispatchQueue.main.async {
            self.paymentInProgress = true
        }
        
        // Call Firebase Cloud Function to create a PaymentIntent and get the client secret
        functions.httpsCallable("createPaymentIntent").call(["amount": amount]) { result, error in
            if let error = error {
                print("Error calling Firebase function: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.paymentInProgress = false
                }
                return
            }
            
            // Extract client secret
            guard let clientSecret = (result?.data as? [String: Any])?["clientSecret"] as? String else {
                print("Error retrieving client secret. Data returned: \(String(describing: result?.data))")
                DispatchQueue.main.async {
                    self.paymentInProgress = false
                }
                return
            }
            
            // Configure PaymentSheet
            var configuration = PaymentSheet.Configuration()
            configuration.merchantDisplayName = "Your Merchant Name"
            
            DispatchQueue.main.async {
                self.paymentSheet = PaymentSheet(paymentIntentClientSecret: clientSecret, configuration: configuration)
                
                // Automatically present the payment sheet after configuration
                self.presentPaymentSheet()
                self.paymentInProgress = false
            }
        }
    }
    
    // Complete payment
    func presentPaymentSheet() {
        guard let paymentSheet = paymentSheet else { return }

        // Find the active UIWindowScene and the first available window
        let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
        guard let rootViewController = windowScene?.windows.first?.rootViewController else {
            print("Error: Could not find root view controller.")
            return
        }

        // Check if the rootViewController is already presenting another view
        if rootViewController.presentedViewController != nil {
            print("Error: rootViewController is already presenting another view controller.")
            return
        }

        paymentSheet.present(from: rootViewController) { paymentResult in
            DispatchQueue.main.async {
                switch paymentResult {
                case .completed:
                    self.paymentSuccess = true
                    print("Payment succeeded!")
                case .failed(let error):
                    self.paymentInProgress = false
                    print("Payment failed: \(error.localizedDescription)")
                case .canceled:
                    self.paymentInProgress = false
                    print("Payment canceled")
                }
            }
        }
    }
}
