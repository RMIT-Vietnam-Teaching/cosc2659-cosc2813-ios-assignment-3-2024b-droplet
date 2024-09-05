/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2023B
 Assessment: Assignment 3
 Author: Do Phan Nhat Anh
 ID: s3915034
 Created date: 05/09/2024
 Last modified: 05/09/2024
 Acknowledgement:
 
 Google Icon - Png Egg
 Facebook Icon - Png Egg
 */

import SwiftUI

struct LoginScreenView: View {
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Login")
                    .font(.largeTitle)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 50)
                
                Spacer()
                
                VStack(spacing: 16) {
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                
                HStack {
                    Spacer()
                    Button(action: {
                        // Forgot Password
                    }) {
                        Text("Forgot your password?")
                            .font(.body)
                            .foregroundColor(.blue)
                    }
                    .padding(.trailing)
                }
                .padding(.top, 8)
                
                // Login Button
                Button(action: {
                    // Login action
                }) {
                    Text("LOGIN")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "2EB5FA"))
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .shadow(radius: 4)
                }
                .padding(.horizontal)
                .padding(.top, 24)
                
                Text("Or login with social account")
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding(.top, 24)
                
                // Login with social account buttons
                HStack(spacing: 16) {
                    Button(action: {
                        // Google login
                    }) {
                        Image("GoogleIcon")
                            .resizable()
                            .padding(10)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                    }
                    
                    Button(action: {
                        // Facebook login
                    }) {
                        Image("FacebookIcon")
                            .resizable()
                            .padding(10)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                    }
                }
                .padding(.top, 16)
                
                Spacer()
            }
            .background(Color(hex: "F9F9F9"))
        }
    }
}

#Preview {
    LoginScreenView()
}
