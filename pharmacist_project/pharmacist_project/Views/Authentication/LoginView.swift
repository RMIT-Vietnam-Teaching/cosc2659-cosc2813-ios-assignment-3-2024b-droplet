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
    
    @State private var navigateToRegister = false
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                VStack {
                    Text("Login")
                        .font(.largeTitle)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, geometry.size.height * 0.05)
                    
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
                        Text("Login")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "2EB5FA"))
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .shadow(radius: 4)
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    // Sign Up Button
                    Button(action: {
                        navigateToRegister = true
                    }) {
                        Text("Sign up")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(Color(hex: "2EB5FA"))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color(hex: "2EB5FA"), lineWidth: 2)
                            )
                    }
                    .padding(.horizontal)
                    .padding(.top, 5)
                    
                    Spacer()
                    
                    // login with social
                    Text("Or login with social account")
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding(.bottom, 8)
                    
                    // Login with social account buttons
                    HStack(spacing: 16) {
                        Button(action: {
                            // Google login
                        }) {
                            Image("GoogleIcon")
                                .interpolation(.none)
                                .resizable()
                                .padding(15)
                                .frame(width: geometry.size.width * 0.12, height: geometry.size.width * 0.12)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                        }
                        
                        Button(action: {
                            // Facebook login
                        }) {
                            Image("FacebookIcon")
                                .resizable()
                                .padding(15)
                                .frame(width: geometry.size.width * 0.12, height: geometry.size.width * 0.12)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                        }
                    }
                    .padding(.bottom, geometry.size.height * 0.02)
                }
                .background(Color(hex: "F9F9F9"))
                .navigationBarBackButtonHidden(true)
                .navigationDestination(isPresented: $navigateToRegister) {
                    RegisterScreenView()
                }
            }
        }
    }
}

#Preview {
    LoginScreenView()
}
