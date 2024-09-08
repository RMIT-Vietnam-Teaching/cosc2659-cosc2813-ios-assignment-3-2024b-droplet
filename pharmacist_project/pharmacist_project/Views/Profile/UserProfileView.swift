//
//  UserProfileView.swift
//  pharmacist_project
//
//  Created by Long Pham Hoang on 8/9/24.
//

import SwiftUI

struct ProfileView: View {
    @State var user: AppUser
    @State private var isOrderPageVisible = false
    @State private var isShippingAddressesPageVisible = false
    @State private var isSettingsPageVisible = false
    
    var body: some View {
        NavigationStack {
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
                    }
                    .padding(.leading)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                Divider()
                
                NavigationLink(destination: OrderPage()) {
                    ProfileRow(title: "My orders", subtitle: "12 orders")
                }
                .buttonStyle(PlainButtonStyle())
                
                NavigationLink(destination: ShippingAddressesPage()) {
                    ProfileRow(title: "Shipping addresses", subtitle: "3 addresses")
                }
                .buttonStyle(PlainButtonStyle())
                
                NavigationLink(destination: SettingsPage()) {
                    ProfileRow(title: "Settings", subtitle: "Notifications, password")
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGray6))
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

struct ShippingAddressesPage: View {
    var body: some View {
        Text("Shipping Addresses Page")
            .navigationTitle("Shipping Addresses")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct SettingsPage: View {
    var body: some View {
        Text("Settings Page")
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
    }
}

// Reusable Row Component
struct ProfileRow: View {
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

#Preview {
    let exampleUser = AppUser(
        id: "12345",
        email: "ngongocthinh124@gmail.com",
        name: "Thịnh Ngô",
        dob: nil,
        address: "123 Main Street",
        phoneNumber: "555-1234",
        photoURL: "https://lh3.googleusercontent.com/a/ACg8ocKLdbqETPr7YbRy08EwxGboIX9bbnAj5YVOat6OUToFR8NsvGo=s96-c",
        createdDate: Date()
    )
    
    return ProfileView(user: exampleUser)
}
