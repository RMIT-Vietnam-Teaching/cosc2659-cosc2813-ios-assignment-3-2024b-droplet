//
//  StripePaymentView.swift
//  pharmacist_project
//
//  Created by Long Pham Hoang on 13/9/24.
//

import SwiftUI

struct StripePaymentView: View {
    @ObservedObject var paymentViewModel = StripePaymentViewModel()
    
    @State var amount: Int
    
    var body: some View {
        VStack {
            Text("Complete Your Payment")

            Button(action: {
                paymentViewModel.initiatePayment(amount: amount)
            }) {
                Text("Proceed to payment")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(paymentViewModel.paymentInProgress)
            .padding()
            
            if paymentViewModel.paymentSuccess {
                Text("Payment Successful!")
                    .foregroundColor(.green)
            }
        }
        .padding()
    }
}

#Preview{
    StripePaymentView(amount: 19500)
}
