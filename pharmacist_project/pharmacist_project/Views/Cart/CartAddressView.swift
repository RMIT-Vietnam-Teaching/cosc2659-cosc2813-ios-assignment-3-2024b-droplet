//
//  CartAddressView.swift
//  pharmacist_project
//
//  Created by Dinh Le Hong Tin on 10/9/24.
//

import SwiftUI

enum AddressType: String, CaseIterable {
    case home = "Home"
    case office = "Office"
    case others = "Others"
}

struct CartAddressView: View {
    @StateObject private var viewModel = CartAddressViewModel()
    
    var payableAmount: Double
    var paymentMethod: PaymentMethod
    var shippingMethod: ShippingMethod
    
    init(payableAmount: Double, paymentMethod: PaymentMethod, shippingMethod: ShippingMethod) {
        self.payableAmount = payableAmount
        self.paymentMethod = paymentMethod
        self.shippingMethod = shippingMethod
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ProgressBar(steps: ["Delivery", "Address"], currentStep: 1)
                    
                    VStack(alignment: .leading) {
                        Text("Full Name*")
                            .font(.headline)
                        TextField("Enter your fullname", text: $viewModel.fullName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Phone Number*")
                            .font(.headline)
                        TextField("Enter your phone number", text: $viewModel.phoneNumber)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.phonePad)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Address*")
                            .font(.headline)
                        TextField("Please add your full address", text: $viewModel.address)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    

                }
                .padding()
            }
            .background(Color.white)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .overlay(
            VStack {
                Spacer()
                Button(action: {
                    Task {
                        try await viewModel.saveAddressAndProceed(payableAmount: payableAmount, paymentMethod: paymentMethod, shippingMethod: shippingMethod)
                    }
                    
                }) {
                    Text("Save Address & Proceed")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#FF6F5C"))
                        .foregroundColor(.white)
                        .cornerRadius(6)
                }
                .padding()
            }
        )
        .onAppear {
            Task {
                await viewModel.loadUserData()
            }
        }
    }
}

#Preview {
    CartAddressView(payableAmount: 1000, paymentMethod: .visa, shippingMethod: .NinjaVan)
}
