//
//  CartAddressView.swift
//  pharmacist_project
//
//  Created by Dinh Le Hong Tin on 10/9/24.
//

import SwiftUI

struct CartAddressView: View {
    @State private var fullName: String = ""
    @State private var phoneNumber: String = ""
    @State private var address: String = ""
    @State private var selectedAddressType: AddressType = .home
    @State private var otherAddressType: String = ""
    
    enum AddressType: String, CaseIterable {
        case home = "Home"
        case office = "Office"
        case others = "Others"
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Progress indicators
                    HStack(spacing: 0) {
                        ProgressBar(steps: ["Delivery", "Address", "Payment", "Place Order"], currentStep: 1)
                    }
                    
                    // Full Name
                    VStack(alignment: .leading) {
                        Text("Full Name*")
                            .font(.headline)
                        TextField("Enter your fullname", text: $fullName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    // Phone Number
                    VStack(alignment: .leading) {
                        Text("Phone Number*")
                            .font(.headline)
                        TextField("Enter your phone number", text: $phoneNumber)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.phonePad)
                    }
                    
                    // Address
                    VStack(alignment: .leading) {
                        Text("Address*")
                            .font(.headline)
                        TextField("Please add your full address", text: $address)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.phonePad)
                    }
                    
                    // Address Type
                    
//                    VStack(alignment: .leading) {
//                        Text("Select an address type")
//                            .font(.headline)
//                        HStack {
//                            ForEach(AddressType.allCases, id: \.self) { type in
//                                Button(action: {
//                                    selectedAddressType = type
//                                }) {
//                                    Text(type.rawValue)
//                                        .padding(.horizontal, 20)
//                                        .padding(.vertical, 10)
//                                        .background(selectedAddressType == type ? Color(hex: "2EB5FA") : Color.gray.opacity(0.2))
//                                        .foregroundColor(selectedAddressType == type ? .white : .black)
//                                        .cornerRadius(6)
//                                }
//                            }
//                        }
//                    }
//                    
//                    // Other Address Type
//                    if selectedAddressType == .others {
//                        TextField("Eg: school, college, temple,ground, etc...", text: $otherAddressType)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                    }
                }
                .padding()
            }
            .background(Color.white)
        }
        .overlay(
            VStack {
                Spacer()
                Button(action: {
                    // Handle save address and proceed action
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
    }
}

#Preview {
    CartAddressView()
}
