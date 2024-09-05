/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2023B
 Assessment: Assignment 3
 Author: Do Phan Nhat Anh
 ID: s3915034
 Created date: 04/09/2024
 Last modified: 04/09/2024
 Acknowledgement:
 Healthcare Medicine Database 1
 */

import SwiftUI

struct SplashScreenView: View {
    @State private var scaleAmount: CGFloat = 1.2
    @State private var titleOpacity: Double = 0
    @State private var backgroundOpacity: Double = 0
    @State private var imageRotation: Double = 0
    @State private var imageOpacity: Double = 0
    
    var body: some View {
        ZStack {
            // Animated background
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.white]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .opacity(backgroundOpacity)
                .ignoresSafeArea()
                .animation(.easeIn(duration: 1.5).delay(0.2), value: backgroundOpacity)
            
            VStack {
                Image("Pharmacy")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(scaleAmount)
                    .rotationEffect(.degrees(imageRotation))
                    .opacity(imageOpacity)
                    .frame(width: 240)
                    .onAppear {
                        withAnimation(.easeOut(duration: 0.8)) {
                            scaleAmount = 0.6
                            imageOpacity = 1.0
                        }
                        
                        withAnimation(.easeInOut(duration: 1).delay(0.8)) {
                            scaleAmount = 1.0
                            imageRotation = 360
                        }
                    }
                
                // Text animation with opacity
                Text("Smart Pharmacy")
                    .font(.custom("Helvetica Neue", size: 36))
                    .foregroundColor(.black)
                    .padding(.top, 30)
                    .opacity(titleOpacity)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1).delay(1.5)) {
                            titleOpacity = 1.0
                        }
                    }
            }
        }
        .onAppear {
            withAnimation {
                backgroundOpacity = 1.0
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
