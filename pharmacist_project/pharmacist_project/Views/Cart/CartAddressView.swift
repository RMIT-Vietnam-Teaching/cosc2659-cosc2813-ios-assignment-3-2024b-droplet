//
//  CartAddressView.swift
//  pharmacist_project
//
//  Created by Dinh Le Hong Tin on 10/9/24.
//

import SwiftUI

struct CartAddressView: View {
    @StateObject private var viewModel = CartDeliveryViewModel()
    @State private var fullName: String = ""
    @State private var phoneNumber: String = ""
    @State private var address: String = ""
    @State private var selectedAddressType: AddressType = .home
    @State private var otherAddressType: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    enum AddressType: String, CaseIterable {
        case home = "Home"
        case office = "Office"
        case others = "Others"
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ProgressBar(steps: ["Delivery", "Address", "Payment", "Place Order"], currentStep: 1)
                    
                    VStack(alignment: .leading) {
                        Text("Full Name*")
                            .font(.headline)
                        TextField("Enter your fullname", text: $fullName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Phone Number*")
                            .font(.headline)
                        TextField("Enter your phone number", text: $phoneNumber)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.phonePad)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Address*")
                            .font(.headline)
                        TextField("Please add your full address", text: $address)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    

                }
                .padding()
            }
            .background(Color.white)
            .navigationTitle("Delivery Address")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .overlay(
            VStack {
                Spacer()
                Button(action: saveAddressAndProceed) {
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
            loadUserData()
        }
    }
    
    private func loadUserData() {
        Task {
            if let user = await AuthenticationService.shared.getAuthenticatedUser() {
                DispatchQueue.main.async {
                    self.fullName = user.name ?? ""
                    self.phoneNumber = user.phoneNumber ?? ""
                    self.address = user.address ?? ""
                }
            }
        }
    }
    
    private func saveAddressAndProceed() {
        guard !fullName.isEmpty, !phoneNumber.isEmpty, !address.isEmpty else {
            showAlert(message: "Please fill in all required fields.")
            return
        }
        
        Task {
            do {
                try await viewModel.updateDeliveryInfo(
                    fullName: fullName,
                    phoneNumber: phoneNumber,
                    address: address,
                    addressType: selectedAddressType.rawValue
                )
                // Navigate to the next screen (e.g., payment screen)
                // You'll need to implement this navigation
            } catch {
                showAlert(message: "Failed to save address: \(error.localizedDescription)")
            }
        }
    }
    
    private func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
}

#Preview {
    CartAddressView()
}
