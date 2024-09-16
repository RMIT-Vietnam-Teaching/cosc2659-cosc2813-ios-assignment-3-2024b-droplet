//
//  CartAddressView.swift
//  pharmacist_project
//
//  Created by Dinh Le Hong Tin on 10/9/24.
//

import SwiftUI

struct CartAddressView: View {
    @StateObject var viewModel: CartAddressViewModel

    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isProcessingPayment {
                    ProgressView("Processing payment...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
                        .padding()
                } else {
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
                            
                            VStack(alignment: .leading) {
                                Text("Note (Optional)")
                                    .font(.headline)
                                TextField("Add a note", text: $viewModel.note)
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
            }
            .overlay(
                VStack {
                    Spacer()
                    if !viewModel.isProcessingPayment {
                        Button(action: {
                            Task {
                                try await viewModel.proceedToPayment()
                            }
                        }) {
                            Text("Confirm & Proceed")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(hex: "#FF6F5C"))
                                .foregroundColor(.white)
                                .cornerRadius(6)
                        }
                        .padding()
                    }
                }
            )
            .onAppear {
                Task {
                    await viewModel.loadUserData()
                }
            }
        }
    }
}

#Preview {
    CartAddressView(viewModel: CartAddressViewModel(payableAmount: 100000, paymentMethod: .visa, shippingMethod: .NinjaVan))
}
