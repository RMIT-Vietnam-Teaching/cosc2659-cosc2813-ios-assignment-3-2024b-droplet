/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 3
  Author: Long Hoang Pham
  ID: s3938007
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
    var actionFailed: (Error?) -> Void 
    
    init(actionSuccess: @escaping () -> Void, actionFailed: @escaping (Error?) -> Void) {
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
                    self.actionFailed(error)
                }
                return
            }
            
            // Extract client secret
            guard let clientSecret = (result?.data as? [String: Any])?["clientSecret"] as? String else {
                let clientSecretError = NSError(domain: "Stripe", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error retrieving client secret."])
                print("Error retrieving client secret. Data returned: \(String(describing: result?.data))")
                DispatchQueue.main.async {
                    self.paymentInProgress = false
                    self.actionFailed(clientSecretError)
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
            }
        }
    }
    
    // Present the payment sheet to complete the payment
    func presentPaymentSheet() {
        guard let paymentSheet = paymentSheet else {
            let paymentSheetError = NSError(domain: "Stripe", code: 0, userInfo: [NSLocalizedDescriptionKey: "PaymentSheet is not configured."])
            print("Error: PaymentSheet is not configured.")
            self.paymentInProgress = false
            self.actionFailed(paymentSheetError)
            return
        }

        // Find the active UIWindowScene and the first available window
        let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
        guard let rootViewController = windowScene?.windows.first?.rootViewController else {
            let rootViewControllerError = NSError(domain: "Stripe", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not find root view controller."])
            print("Error: Could not find root view controller.")
            self.paymentInProgress = false
            self.actionFailed(rootViewControllerError)
            return
        }

        // Check if the rootViewController is already presenting another view
        if rootViewController.presentedViewController != nil {
            let rootViewControllerBusyError = NSError(domain: "Stripe", code: 0, userInfo: [NSLocalizedDescriptionKey: "RootViewController is already presenting another view controller."])
            print("Error: rootViewController is already presenting another view controller.")
            self.paymentInProgress = false
            self.actionFailed(rootViewControllerBusyError)
            return
        }

        paymentSheet.present(from: rootViewController) { paymentResult in
            DispatchQueue.main.async {
                switch paymentResult {
                case .completed:
                    self.paymentSuccess = true
                    self.paymentInProgress = false
                    print("Payment succeeded!")
                    self.actionSuccess()
                case .failed(let error):
                    self.paymentInProgress = false
                    print("Payment failed: \(error.localizedDescription)")
                    self.actionFailed(error)
                case .canceled:
                    let cancelError = NSError(domain: "Stripe", code: 0, userInfo: [NSLocalizedDescriptionKey: "Payment canceled"])
                    self.paymentInProgress = false
                    print("Payment canceled")
                    self.actionFailed(cancelError)
                }
            }
        }
    }
}
