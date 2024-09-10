//
//  UserProfileView.swift
//  pharmacist_project
//
//  Created by Long Pham Hoang on 8/9/24.
//

import SwiftUI

import SwiftUI

struct UserProfileView: View {
    @StateObject var viewModel = UserProfileViewModel()
    
    var body: some View {
        NavigationStack {
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
                            
                            Text("\(user.address ?? "Address not specified")")
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
                }
                .navigationTitle("Profile")
                .navigationBarTitleDisplayMode(.inline)
                .background(Color(.systemGray6))
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        .onAppear {
            viewModel.loadAuthenticatedUser()
        }
    }
}


// Mock pages for example
struct OrderPage: View {
    var body: some View {
        Text("Order Page")
            .navigationTitle("My Orders")
            .navigationBarTitleDisplayMode(.inline)
    }
}

// Reusable Row Component
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
