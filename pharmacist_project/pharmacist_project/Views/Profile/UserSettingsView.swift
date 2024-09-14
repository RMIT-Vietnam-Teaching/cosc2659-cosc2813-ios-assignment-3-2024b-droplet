//
//  UserSettingsView.swift
//  pharmacist_project
//
//  Created by Long Pham Hoang on 9/9/24.
//

import SwiftUI

struct UserSettingsView: View {
    @ObservedObject var viewModel: UserProfileViewModel
    
    @State private var isEditing = false
    @State private var tempName: String = ""
    @State private var tempDob: Date = Date()
    @State private var tempPhoneNumber: String = ""
    @State private var tempAddress: String = ""
    
    @State private var dailyHealthTipsNotification = true
    @State private var deliveryStatusNotification = false
    
    @AppStorage("appearanceMode") private var appearanceMode: ColorSchemeMode = .automatic
    
    
    var body: some View {
        ScrollView{
            if let user = viewModel.user {
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
                            
                            TextField("Address", text: $tempAddress)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                        } else {
                            HStack {
                                Text("Full name")
                                    .font(.headline)
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
                                    .font(.headline)
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
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text(user.phoneNumber ?? "Not provided")
                                    .foregroundColor(.primary)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Address")
                                        .font(.headline)
                                        .foregroundColor(.secondary)
                                    
                                    Spacer()
                                    
                                    Text(user.address ?? "Not provided")
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                
                                Spacer()
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Button(action: {
                        if isEditing {
                            viewModel.updateUser(name: tempName, dob: tempDob, phoneNumber: tempPhoneNumber, address: tempAddress)
                        } else {
                            tempName = user.name ?? ""
                            tempDob = user.dob ?? Date()
                            tempPhoneNumber = user.phoneNumber ?? ""
                            tempAddress = user.address ?? ""
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
                    
                    if user.type == .customer {
                        Divider()
                        
                        Text("Notifications")
                            .font(.title2)
                            .padding(.leading)
                        
                        VStack {
                            Toggle(isOn: Binding(
                                get: { viewModel.userPreference?.receiveDailyHealthTip ?? false },
                                set: { newValue in
                                    viewModel.toggleReceiveHealthTip(newValue)
                                }
                            )) {
                                Text("Daily health tips")
                            }
                            
                            Toggle(isOn: Binding(
                                get: { viewModel.userPreference?.receiveDeliveryStatus ?? false },
                                set: { newValue in
                                    viewModel.toggleReceiveDeliveryStatus(newValue)
                                }
                            )) {
                                Text("Delivery status")
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                    
                    Divider()
                    
                    Text("Appearance Mode")
                        .font(.title2)
                        .padding(.leading)
                    
                    Picker("Appearance", selection: $appearanceMode) {
                        Text("Automatic").tag(ColorSchemeMode.automatic)
                        Text("Light Mode").tag(ColorSchemeMode.light)
                        Text("Dark Mode").tag(ColorSchemeMode.dark)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    .onChange(of: appearanceMode) { newMode in
                        viewModel.updateAppearanceMode(newMode)
                    }
                    
                    Spacer()
                }
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
                .padding(.top)
                .background(Color(.systemGray6).ignoresSafeArea())
            } else {
                ProgressView("Loading...")
            }
        }
    }
}
