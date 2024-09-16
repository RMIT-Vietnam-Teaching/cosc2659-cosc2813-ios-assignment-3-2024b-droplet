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

struct RegisterScreenView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var regisVM = RegistrationViewModel()
    
    @State private var navigateToLogin = false
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                VStack {
                    Text("Sign up")
                        .font(.largeTitle)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, geometry.size.height * 0.05)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    
                    Spacer()
                    
                    VStack(spacing: 16) {
                        TextField("Name", text: $regisVM.name)
                            .padding()
                            .background(colorScheme == .dark ? Color(UIColor.systemGray5) : Color(UIColor.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal)
                        
                        TextField("Email", text: $regisVM.email)
                            .padding()
                            .background(colorScheme == .dark ? Color(UIColor.systemGray5) : Color(UIColor.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal)
                        
                        SecureField("Password", text: $regisVM.password)
                            .padding()
                            .background(colorScheme == .dark ? Color(UIColor.systemGray5) : Color(UIColor.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal)
                        
                        SecureField("Confirm Password", text: $regisVM.confirmPassword)
                            .padding()
                            .background(colorScheme == .dark ? Color(UIColor.systemGray5) : Color(UIColor.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal)
                        
                        if let errorMessage = regisVM.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding(.horizontal)
                        }
                    }
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            navigateToLogin = true
                        }) {
                            Text("Already have an account?")
                                .font(.body)
                                .foregroundColor(.blue)
                        }
                        .padding(.trailing)
                    }
                    .padding(.top, 8)
                    
                    // Sign up button
                    LoadingButton(title: "Sign up", state: $regisVM.signUpButtonState, style: .fill) {
                        regisVM.register()
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    Spacer()
                    
                    Text("Or register with social account")
                        .font(.body)
                        .foregroundColor(colorScheme == .dark ? .gray : .black)
                        .padding(.top, geometry.size.height * 0.03)
                    
                    HStack(spacing: 16) {
                        Button(action: {
                            regisVM.signInGoogle()
                        }) {
                            Image("GoogleIcon")
                                .resizable()
                                .padding(15)
                                .frame(width: geometry.size.width * 0.12, height: geometry.size.width * 0.12)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                        }
                        
                        Button(action: {
                            regisVM.signInFacebook()
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
                .background(colorScheme == .dark ? Color.black : Color(hex: "F9F9F9"))
                .navigationBarBackButtonHidden(true)
                .navigationDestination(isPresented: $navigateToLogin) {
                    LoginScreenView()
                }
                .navigationDestination(isPresented: $regisVM.isShowHomeView) {
                    HomeView()
                }
            }
        }
    }
}

#Preview {
    RegisterScreenView()
}
