/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Author:
    Long Pham Hoang
    Do Phan Nhat Anh (s3915034)
  Created  date: 04/09/2024
  Last modified: 04/09/2024
  Acknowledgement:
*/

import SwiftUI

struct ContentView: View {
    @State var isLoginScreen = false
    
    var body: some View {
        ZStack {
            if isLoginScreen {
                LoginScreenView()
            } else {
                SplashScreenView(isLoginScreen: $isLoginScreen)
            }
        }
    }
}


#Preview {
    ContentView()
}
