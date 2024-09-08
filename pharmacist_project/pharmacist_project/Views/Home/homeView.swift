//
//  homeView.swift
//  pharmacist_project
//
//  Created by Leon Do on 5/9/24.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var user: AppUser? = nil
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("home view")
                
                Button {
                    signOut()
                } label: {
                    Text("log out")
                }
                
                if let user = user {
                    NavigationLink(destination: ProfileView(user: user)) {
                        Text("Go to Profile")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                }
            }
            .onAppear {
                Task {
                    await userProfile()
                    print(user!)
                }
            }
        }
        .navigationTitle("Home")
        .navigationBarHidden(true)
    }
    
    func signOut() {
        let errorMsg = AuthenticationService.shared.signOut()
        if errorMsg != nil {
            print("sign out error \(errorMsg!)")
        } else {
            print("sign out success")
            dismiss()
        }
    }
    
    func userProfile() async {
        self.user = await AuthenticationService.shared.getAuthenticatedUser()
        if let user = user {
            print("User profile fetched: \(user.name ?? "Unknown")")
        } else {
            print("No user logged in")
        }
    }
}

#Preview {
    HomeView()
}

