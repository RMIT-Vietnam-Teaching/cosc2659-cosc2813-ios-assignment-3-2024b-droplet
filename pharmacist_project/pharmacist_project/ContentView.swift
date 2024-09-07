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
    
    @State var isShowHomeView = false
    
    var body: some View {
        NavigationStack {
            LoginScreenView()
        }
    }
}

#Preview {
    ContentView()
}
