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
    @State private var isShowAvatarUploadView = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let user = viewModel.user {
                    VStack(alignment: .leading, spacing: 16) {
                        Divider()
                        
                        HStack {
                            AsyncImage(url: URL(string: user.photoURL ?? "defaultUserProfile")) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())
                                } else if phase.error != nil {
                                    Image("defaultUserProfile")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())
                                } else {
                                    ProgressView()
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())
                                }
                            }
                            .overlay(
                                VStack {
                                    Button(action: {
                                        isShowAvatarUploadView = true
                                    }, label: {
                                        Image(systemName: "pencil.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(.white)
                                            .padding(4)
                                            .background(Color.black.opacity(0.24))
                                            .clipShape(Circle())
                                            .position(x: 80, y: 80)
                                    })
                                }
                            )
                            
                            VStack(alignment: .leading) {
                                Text(user.name ?? "N/A")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.primary)
                                
                                Text(user.email ?? "N/A")
                                    .font(.subheadline)
                                    .foregroundColor(Color.secondary)
                                
                                Text(user.address ?? "Address not specified")
                                    .font(.subheadline)
                                    .foregroundColor(Color.secondary)
                            }
                            .padding(.leading)
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        Divider()
                        
                        NavigationLink(destination: OrderView(orderViewModel: OrderViewModel())) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("My orders")
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    Text("Check your orders")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(8)
                            .shadow(color: Color.gray.opacity(0.2), radius: 2, x: 0, y: 1)
                            .padding(.horizontal)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        NavigationLink(destination: UserSettingsView(viewModel: viewModel)) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Settings")
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    Text("Notifications, Name, Phone Number,...")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(8)
                            .shadow(color: Color.gray.opacity(0.2), radius: 2, x: 0, y: 1)
                            .padding(.horizontal)
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
                                .background(Color(.systemBackground))
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
                    .background(Color(.systemGroupedBackground))  
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
        
        .navigationDestination(isPresented: $isShowAvatarUploadView) {
            ImageUploadView(userProfileViewModel: viewModel)
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

#Preview {
    ContentView()
}
