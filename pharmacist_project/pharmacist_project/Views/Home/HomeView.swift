//
//  BottomBarView.swift
//  pharmacist_project
//
//  Created by Leon Do on 10/9/24.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // HomeView Tab
            MedicineView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("Home")
                }
                .tag(0)
            
            // ChatBot Tab
            ChatView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "message.fill" : "message")
                    Text("ChatBot")
                }
                .tag(1)
            
            // Profile Tab
            UserProfileView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "person.fill" : "person")
                    Text("Profile")
                }
                .tag(2)
        }
        .accentColor(Color(hex: "2EB5FA"))
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor { traitCollection in
                return traitCollection.userInterfaceStyle == .dark ? UIColor.black : UIColor.white
            }
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
            UITabBar.appearance().unselectedItemTintColor = UIColor.gray
        }
    }
}

#Preview {
    HomeView()
}
