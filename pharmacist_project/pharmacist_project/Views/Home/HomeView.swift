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
