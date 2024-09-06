/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2023B
 Assessment: Assignment 3
 Author: Do Phan Nhat Anh
 ID: s3915034
 Created date: 06/09/2024
 Last modified: 06/09/2024
 Acknowledgement:
 */


import SwiftUI

struct AddToCartButtonView: View {
    var body: some View {
        Button(action: {
            // Logic for button
        }) {
            Text("Add to Cart")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.4))
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 40)
                .background(Color(UIColor.white))
                .cornerRadius(5)
        }
        .frame(maxWidth: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: 0)
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
        )
    }
}

#Preview {
    AddToCartButtonView()
}
