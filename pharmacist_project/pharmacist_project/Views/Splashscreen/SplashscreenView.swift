/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2023B
 Assessment: Assignment 3
 Author: Do Phan Nhat Anh
 ID: s3915034
 Created date: 04/09/2024
 Last modified: 05/09/2024
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
        GeometryReader { geometry in
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(hex: "#2EB5FA").opacity(0.2), Color(hex: "#FAFBFC")]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .opacity(backgroundOpacity)
                    .ignoresSafeArea()
                
                VStack {
                    Image("Pharmacy")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(scaleAmount)
                        .rotationEffect(.degrees(imageRotation))
                        .opacity(imageOpacity)
                        .frame(width: geometry.size.width * 0.6)
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
                    
                    Text("Smart Pharmacy")
                        .font(.custom("Helvetica Neue", size: geometry.size.width * 0.1)) 
                        .foregroundColor(.black)
                        .padding(.top, geometry.size.height * 0.05)
                        .opacity(titleOpacity)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1).delay(1.5)) {
                                titleOpacity = 1.0
                            }
                        }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .onAppear {
                withAnimation {
                    backgroundOpacity = 1.0
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
