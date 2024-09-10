//
//  homeView.swift
//  pharmacist_project
//
//  Created by Leon Do on 5/9/24.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Home View")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                    
                    NavigationLink(destination: UserProfileView()) {
                        Text("Go to Profile")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }

                
                Button {
                    signOut()
                } label: {
                    Text("Log Out")
                        .font(.headline)
                        .foregroundColor(.red)
                }
            }
            .padding()
        }
        .navigationTitle("Home")
        .navigationBarHidden(true)
    }
    
    func signOut() {
        let errorMsg = AuthenticationService.shared.signOut()
        if errorMsg != nil {
            print("Sign out error: \(errorMsg!)")
        } else {
            print("Sign out successful")
            dismiss()
        }
    }
}

#Preview {
    HomeView()
}

