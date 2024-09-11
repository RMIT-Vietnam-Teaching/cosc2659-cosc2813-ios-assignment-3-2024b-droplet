/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2023B
 Assessment: Assignment 3
 Author: Do Phan Nhat Anh
 ID: s3915034
 Created date: 1/09/2024
 Last modified: 11/09/2024
 Acknowledgement:
 */


import SwiftUI

struct BuyNowButtonView: View {
    var body: some View {
        Button(action: {
            // buy now
            print("Buy Now")
        }) {
            Text("Buy Now")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 40)
                .background(Color(UIColor.orange))
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
    BuyNowButtonView()
}
