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
    @Environment(\.colorScheme) var colorScheme
    @StateObject var loginVM = LoginViewModel()
    @StateObject private var viewModel = UserProfileViewModel()
    
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
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    
                    Spacer()
                    
                    VStack(spacing: 16) {
                        TextField("Email", text: $loginVM.email)
                            .padding()
                            .background(colorScheme == .dark ? Color(UIColor.systemGray5) : Color(UIColor.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal)
                        
                        SecureField("Password", text: $loginVM.password)
                            .padding()
                            .background(colorScheme == .dark ? Color(UIColor.systemGray5) : Color(UIColor.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal)
                    }
                    
                    if let errorMessage = loginVM.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }
                    
                    // Login Button
                    LoadingButton(title: "Login", state: $loginVM.loginButtonState, style: .fill) {
                        // Login action
                        loginVM.signIn()
                    }
                    .padding(.horizontal)
                    .padding(.top, 15)
                    
                    // Sign Up Button
                    LoadingButton(title: "Sign up", state: $loginVM.signUpButtonState, style: .outline) {
                        navigateToRegister = true
                    }
                    .padding(.horizontal)
                    .padding(.top, 6)
                    
                    Spacer()
                    
                    // login with social
                    Text("Or login with social account")
                        .font(.body)
                        .foregroundColor(colorScheme == .dark ? .gray : .black)
                        .padding(.bottom, 8)
                    
                    // Login with social account buttons
                    HStack(spacing: 16) {
                        Button(action: {
                            loginVM.signInGoogle()
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
                            loginVM.signInFacebook()
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
                .onAppear {
                    if loginVM.isUserLoggedIn() {
                        loginVM.isShowHomeView = true
                    } else {
                        loginVM.isShowHomeView = false
                    }
                }
                .background(colorScheme == .dark ? Color.black : Color(hex: "F9F9F9"))
                .navigationBarBackButtonHidden(true)
                
                .navigationDestination(isPresented: $navigateToRegister) {
                    RegisterScreenView()
                        .navigationBarHidden(true)
                }
                .navigationDestination(isPresented: $loginVM.isShowHomeView) {
                    HomeView()
                        .navigationBarHidden(true)
                }
            }
        }
    }
}

#Preview {
    LoginScreenView()
}
