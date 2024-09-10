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
                        ProgressCircle(text: "Delivery", isActive: true)
                        ProgressCircle(text: "Address", isActive: true)
                        ProgressCircle(text: "Payment", isActive: false)
                        ProgressCircle(text: "Place Order", isActive: false)
                    }
                    .padding()
                    
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
                        TextEditor(text: $address)
                            .frame(height: 100)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                    }
                    
                    // Address Type
                    VStack(alignment: .leading) {
                        Text("Select an address type")
                            .font(.headline)
                        HStack {
                            ForEach(AddressType.allCases, id: \.self) { type in
                                Button(action: {
                                    selectedAddressType = type
                                }) {
                                    Text(type.rawValue)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 10)
                                        .background(selectedAddressType == type ? Color.blue : Color.gray.opacity(0.2))
                                        .foregroundColor(selectedAddressType == type ? .white : .black)
                                        .cornerRadius(20)
                                }
                            }
                        }
                    }
                    
                    // Other Address Type
                    if selectedAddressType == .others {
                        TextField("Eg: school, college, temple,ground, etc...", text: $otherAddressType)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                .padding()
            }
            .navigationTitle("Cart (1 items)")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button(action: {
                // Handle back action
            }) {
                Image(systemName: "chevron.left")
            })
            .background(Color.gray.opacity(0.1))
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
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
        )
    }
}

#Preview {
    CartAddressView()
}
