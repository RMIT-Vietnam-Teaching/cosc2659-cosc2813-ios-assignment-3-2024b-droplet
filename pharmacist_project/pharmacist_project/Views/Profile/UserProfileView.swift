//
//  UserProfileView.swift
//  pharmacist_project
//
//  Created by Long Pham Hoang on 8/9/24.
//

import SwiftUI

struct UserProfileView: View {
    @StateObject var viewModel = UserProfileViewModel()
    @State private var showLogoutAlert = false
    @State private var isLoggingOut = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let user = viewModel.user {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("My profile")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.leading)
                        
                        HStack {
                            AsyncImage(url: URL(string: user.photoURL ?? "defaultUserProfile")) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 70, height: 70)
                                        .clipShape(Circle())
                                } else if phase.error != nil {
                                    Image("defaultUserProfile")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 70, height: 70)
                                        .clipShape(Circle())
                                } else {
                                    ProgressView()
                                        .frame(width: 70, height: 70)
                                        .clipShape(Circle())
                                }
                            }
                            
                            VStack(alignment: .leading) {
                                Text(user.name ?? "N/A")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                
                                Text(user.email ?? "N/A")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Text(user.address ?? "Address not specified")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.leading)
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        Divider()
                        
                        NavigationLink(destination: OrderPage()) {
                            UserProfileRow(title: "My orders", subtitle: "12 orders")
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        NavigationLink(destination: UserSettingsView(viewModel: viewModel)) {
                            UserProfileRow(title: "Settings", subtitle: "Notifications, Name, Phone Number,...")
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Spacer()
                        
                        Button(action: {
                            showLogoutAlert = true
                        }) {
                            Text("Log Out")
                                .font(.headline)
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                        .alert("Are you sure you want to log out?", isPresented: $showLogoutAlert) {
                            Button("Cancel", role: .cancel) {}
                            Button("Log Out", role: .destructive) {
                                logOutWithDelay()
                            }
                        }
                    }
                    .navigationTitle("Profile")
                    .navigationBarTitleDisplayMode(.inline)
                    .background(Color(.systemGray6))
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                
                if isLoggingOut {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    
                    VStack {
                        ProgressView("Logging out...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.5, anchor: .center)
                            .padding()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.4))
                    .ignoresSafeArea()
                }
            }
        }
        .onAppear {
            viewModel.loadAuthenticatedUser()
        }
    }
    
    func logOutWithDelay() {
        isLoggingOut = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            viewModel.signOut()
            isLoggingOut = false
        }
    }
}

struct OrderPage: View {
    var body: some View {
        Text("Order Page")
            .navigationTitle("My Orders")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct UserProfileRow: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: Color.gray.opacity(0.2), radius: 2, x: 0, y: 1)
        .padding(.horizontal)
    }
}
