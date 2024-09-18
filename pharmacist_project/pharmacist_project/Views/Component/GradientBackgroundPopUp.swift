/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 3
  Author: Ngo Ngoc Thinh
  ID: s3879364
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
import Foundation

struct GradientBackgroundPopup<Content>: View where Content: View {
    var title: String
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        ZStack {
            // Dimmed background covering the entire screen
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            
            // Popup content
            VStack {
                ZStack {
                    // Title in the center
                    Text(title)
                        .font(.title)
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
                .padding(.top)
                
                // ScrollView for content
                ScrollView {
                    content()
                        .padding()
                }
                
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.7)
            .background(GradientBackground())
            .cornerRadius(20)
            .shadow(radius: 10)
        }
    }
}

#Preview {
    GradientBackgroundPopup(title: "Popup", content: {
        VStack(spacing: 24) {
            Image("order-placed")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 160)
            
            Text("Order placed")
                .font(.title2)
                .foregroundColor(.white)
            
            Spacer()
            Spacer()
            
            LoadingButton(title: "Back Home", state: .constant(.active), style: .fill) {
                
            }
            .padding(.horizontal)
        }
        .padding(.top)
        .padding(.top)
    })
}
