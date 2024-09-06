/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2023B
 Assessment: Assignment 3
 Author: Long Pham Hoang
 ID:
 Created  date: 04/09/2024
 Last modified: 04/09/2024
 Acknowledgement:
 */

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack {
            AuthenView()
        }
        .onAppear {
            if isUserLoggedIn() {
                // adjust state var to open sign in view. Ex: self.isShowSignInView = true
            } else {
                // adjust state var to open home view
            }
        }
    }
    
    private func isUserLoggedIn() -> Bool {
        // get user from previous sign in
        let user = try? AuthenticationService.shared.getAuthenticatedUser()
        if user != nil {
            print("success get previous authenticated user \(user?.email ?? "")")
        } else {
            print("need to sign in")
        }
        return user != nil
    }
}

#Preview {
    ContentView()
}
