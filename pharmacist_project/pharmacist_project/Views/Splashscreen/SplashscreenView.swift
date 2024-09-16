/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 3
  Author: Do Phan Nhat Anh
  ID: s3915034
  Created  date: 05/09/2024
  Last modified: 16/09/2024
  Acknowledgement:
     https://rmit.instructure.com/courses/138616/modules/items/6274581
     https://rmit.instructure.com/courses/138616/modules/items/6274582
     https://rmit.instructure.com/courses/138616/modules/items/6274583
     https://rmit.instructure.com/courses/138616/modules/items/6274584
     https://rmit.instructure.com/courses/138616/modules/items/6274585
     https://rmit.instructure.com/courses/138616/modules/items/6274586
     https://rmit.instructure.com/courses/138616/modules/items/6274588
     https://rmit.instructure.com/courses/138616/modules/items/6274589
     https://rmit.instructure.com/courses/138616/modules/items/6274590
     https://rmit.instructure.com/courses/138616/modules/items/6274591
     https://rmit.instructure.com/courses/138616/modules/items/6274592
     https://developer.apple.com/documentation/swift/
     https://developer.apple.com/documentation/swiftui/
*/

import SwiftUI

struct SplashScreenView: View {
    @State private var scaleAmount: CGFloat = 1.2
    @State private var titleOpacity: Double = 0
    @State private var backgroundOpacity: Double = 0
    @State private var imageRotation: Double = 0
    @State private var imageOpacity: Double = 0
    @State private var navigateToNextView = false
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
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
                    
                    // Fake delay using DispatchQueue
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        navigateToNextView = true // Set state to navigate after 2 seconds
                    }
                }
                .navigationDestination(isPresented: $navigateToNextView) {
                    LoginScreenView()
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
