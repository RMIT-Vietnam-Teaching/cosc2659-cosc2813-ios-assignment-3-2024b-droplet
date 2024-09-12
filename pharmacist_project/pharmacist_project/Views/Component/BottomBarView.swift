//
//  BottomBarView.swift
//  pharmacist_project
//
//  Created by Leon Do on 10/9/24.
//

import SwiftUI

struct BottomBarView: View {
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // HomeView Tab
            HomeView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("Home")
                }
                .tag(0)
            
            // ChatBot Tab
            ChatBotView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "message.fill" : "message")
                    Text("ChatBot")
                }
                .tag(1)
            
            // Profile Tab
            ProfileView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "person.fill" : "person")
                    Text("Profile")
                }
                .tag(2)
        }
        .background(Color.white)
        .accentColor(Color(hex: "2EB5FA"))
        .onAppear {
            UITabBar.appearance().backgroundColor = UIColor.white
            UITabBar.appearance().unselectedItemTintColor = UIColor.gray
        }
    }
}

// Example ChatBot and Profile views
struct ChatBotView: View {
    var body: some View {
        Text("ChatBot Screen")
    }
}

struct ProfileView: View {
    var body: some View {
        Text("Profile Screen")
    }
}

#Preview {
    BottomBarView()
}
