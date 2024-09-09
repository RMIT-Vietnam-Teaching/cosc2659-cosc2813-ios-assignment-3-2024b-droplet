//
//  UserSettingsView.swift
//  pharmacist_project
//
//  Created by Long Pham Hoang on 9/9/24.
//

import SwiftUI

struct UserSettingsView: View {
    @Binding var user: AppUser
    
    // will fix this when integrate with backend
    @State private var isEditing = false
    @State private var tempName: String = ""
    @State private var tempDob: Date = Date()
    @State private var tempPhoneNumber: String = ""
    
    @State private var dailyHealthTipsNotification = true
    @State private var salesNotification = true
    @State private var deliveryStatusNotification = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Personal Information")
                .font(.title2)
                .padding(.leading)
            
            Divider()
            
            VStack(spacing: 16) {
                if isEditing {
                    TextField("Full name", text: $tempName)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    
                    DatePicker("Date of Birth", selection: $tempDob, displayedComponents: .date)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    
                    TextField("Phone number", text: $tempPhoneNumber)
                        .keyboardType(.phonePad)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                } else {
                    HStack {
                        Text("Full name")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(user.name ?? "Not provided")
                            .foregroundColor(.primary)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    
                    HStack {
                        Text("Date of Birth")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(user.dob?.formatted(date: .numeric, time: .omitted) ?? "Not provided")
                            .foregroundColor(.primary)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    
                    HStack {
                        Text("Phone number")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(user.phoneNumber ?? "Not provided")
                            .foregroundColor(.primary)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
            }
            .padding(.horizontal)
            
            Button(action: {
                if isEditing {
                    user.name = tempName.isEmpty ? nil : tempName
                    user.dob = tempDob
                    user.phoneNumber = tempPhoneNumber.isEmpty ? nil : tempPhoneNumber
                } else {
                    tempName = user.name ?? ""
                    tempDob = user.dob ?? Date()
                    tempPhoneNumber = user.phoneNumber ?? ""
                }
                isEditing.toggle()
            }) {
                Text(isEditing ? "Save" : "Edit")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isEditing ? Color.green : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            
            Spacer()
            
            Divider()
            
            Text("Notifications")
                .font(.title2)
                .padding(.leading)
            
            VStack {
                Toggle(isOn: $dailyHealthTipsNotification) {
                    Text("Daily health tips")
                }
                Toggle(isOn: $salesNotification) {
                    Text("Sales")
                }
                Toggle(isOn: $deliveryStatusNotification) {
                    Text("Delivery status")
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .padding(.top)
        .background(Color(.systemGray6).ignoresSafeArea())
    }
}

#Preview {
    @State var exampleUser = AppUser(
        id: "12345",
        email: "ngongocthinh124@gmail.com",
        name: "Thịnh Ngô",
        dob: Date(),
        address: "123 Main Street",
        phoneNumber: "555-1234",
        photoURL: nil,
        createdDate: Date()
    )
    
    return NavigationStack {
        UserSettingsView(user: $exampleUser)
    }
}
