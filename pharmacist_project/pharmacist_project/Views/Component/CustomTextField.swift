//
//  CustomTextField.swift
//  pharmacist_project
//
//  Created by Dinh Le Hong Tin on 13/9/24.
//

import SwiftUI

struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    var height: CGFloat = 50
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding(.horizontal, 16)
            .frame(height: height)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(UIColor.systemGray6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color(UIColor.systemGray4), lineWidth: 1)
            )
    }
}

struct CustomTextFieldPreview: View {
    @State private var text = ""
    
    var body: some View {
        VStack(spacing: 20) {
            CustomTextField(placeholder: "Enter your fullname", text: $text, height: 100)
        }
        .padding()
    }
}

#Preview {
    CustomTextFieldPreview()
}
