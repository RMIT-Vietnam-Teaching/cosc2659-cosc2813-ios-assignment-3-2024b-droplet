/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2023B
 Assessment: Assignment 3
 Author: Do Phan Nhat Anh
 ID: s3915034
 Created  date: 04/09/2024
 Last modified: 04/09/2024
 Acknowledgement:
 
 Healthcare Medicine Database 1
 */

import SwiftUI

struct SplashScreenView: View {
    @Binding var isLoginScreen: Bool
    @State var scaleAmount: CGFloat = 1
    @State var titleOpacity: Double = 0
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            VStack {
                Image("Pharmacy")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(scaleAmount)
                    .frame(width: 120)
                
                Text("Smart Pharmacy")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.top, 20)
                    .opacity(titleOpacity)
            }
            .onAppear {
                withAnimation(.easeOut(duration: 0.5)) {
                    scaleAmount = 0.6
                }
                
                withAnimation(.easeInOut(duration: 1).delay(0.5)) {
                    scaleAmount = 1.0
                }
                
                withAnimation(.easeInOut(duration: 1).delay(1.0)) {
                    titleOpacity = 1.0
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    isLoginScreen = true
                }
            }
        }
    }
}

