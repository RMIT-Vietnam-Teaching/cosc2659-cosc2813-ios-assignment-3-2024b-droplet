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
                    
                    Spacer()
                    
                    VStack(spacing: 16) {
                        TextField("Name", text: $regisVM.name)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal)
                        
                        TextField("Email", text: $regisVM.email)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal)
                        
                        SecureField("Password", text: $regisVM.password)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal)
                        
                        SecureField("Confirm Password", text: $regisVM.confirmPassword)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal)
                        
                        if regisVM.errorMessage != nil {
                            Text(regisVM.errorMessage!)
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
                    
                    // MARK: Register Button
                    Button(action: {
                        regisVM.register()
                    }) {
                        Text("Sign up")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "2EB5FA"))
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .shadow(radius: 4)
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    Spacer()
                    
                    Text("Or register with social account")
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding(.top, geometry.size.height * 0.03)
                    
                    // MARK: Register with social account buttons
                    HStack(spacing: 16) {
                        Button(action: {
                            // MARK: Google register
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
                            // MARK: Facebook register
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
