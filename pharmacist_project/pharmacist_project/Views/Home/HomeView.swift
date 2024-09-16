//
//  BottomBarView.swift
//  pharmacist_project
//
//  Created by Leon Do on 10/9/24.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedTab: Int = 0
    
    @State private var isShowNotificationPermissionAlert = false
    
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
            
            // setup notification
            requestNotificationPermissionForTheFirstTime()
            Task {
                NotificationService.shared.scheduleDailyNotifications(dailyNotificationRequests: try await NotificationService.getStaticDailyNotificationRequests())
            }
        }
        .alert(isPresented: $isShowNotificationPermissionAlert) {
            Alert(
                title: Text("Notification Permission"),
                message: Text("Your application's notification is turned off hence your account notification's settings will do not have effect. Please turn notification on."),
                primaryButton: .default(Text("Settings"), action: {
                    // Action to open settings or request permissions
                    if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
                        UIApplication.shared.open(appSettings)
                    }
                }),
                secondaryButton: .cancel(Text("Cancel"))
            )
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func requestNotificationPermissionForTheFirstTime() {
        Task {
            let allowNotification = await NotificationService.shared.requestPermissionForTheFirstTime()
            if !allowNotification {
                print("not allow notification")
                if let user = await AuthenticationService.shared.getAuthenticatedUser() {
                    var userPreference = try await UserPreferenceService.shared.getUserPreference(userId: user.id)
                    if userPreference.receiveDailyHealthTip {
                        isShowNotificationPermissionAlert = true
                    }
                    print("update user's preference receiveDailyHealthTip to false")
                } else {
                    print("No authenticated user found.")
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
