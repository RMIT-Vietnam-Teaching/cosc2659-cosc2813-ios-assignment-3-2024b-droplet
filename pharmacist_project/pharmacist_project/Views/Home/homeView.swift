//
//  homeView.swift
//  pharmacist_project
//
//  Created by Leon Do on 5/9/24.
//

import Foundation
import SwiftUI

struct HomeView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Text("home view")
        
        Button {
            signOut()
        } label: {
            Text("log out")
        }
    }
    
    func signOut() {
        let errorMsg = AuthenticationService.shared.signOut()
        if errorMsg != nil {
            print("sign out error \(errorMsg!)")
        } else {
            print("sign out success")
            dismiss()
        }
    }
}
