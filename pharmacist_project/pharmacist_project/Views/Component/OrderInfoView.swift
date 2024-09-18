/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 3
  Author: Dinh Le Hong Tin
  ID: s3932134
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

struct OrderInfoView: View {
    let order: Order
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Order Information")
                .font(.headline)
                .fontWeight(.regular)
            
            InfoRow(title: "Shipping Address:") {
                Text(order.address ?? "No address provided")
            }
            
            InfoRow(title: "Payment Method:", isImage: order.paymentMethod == .visa) {
                if order.paymentMethod == .COD {
                    Text("Cash on Delivery")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                } else {
                    Image("Visa")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 65)
                        .padding(.leading, -27)
                }
            }
            
            InfoRow(title: "Delivery Method:") {
                Text(order.shippingMethod?.toString ?? "Unknown delivery method")
            }
            
            InfoRow(title: "Discount:") {
                Text(order.totalDiscount?.formatAsCurrency() ?? "No discount")
            }
            
            InfoRow(title: "Total Amount:") {
                Text(order.payable?.formatAsCurrency() ?? "Unknown")
            }
        }
        .padding()
        .background(colorScheme == .dark ? Color.gray.opacity(0.2) : Color.white)
        .cornerRadius(10)
        .shadow(color: colorScheme == .dark ? Color.black.opacity(0.3) : Color.gray.opacity(0.2), radius: 2)
    }
}

struct InfoRow<Content: View>: View {
    let title: String
    let content: () -> Content
    let isImage: Bool
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    init(title: String, isImage: Bool = false, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
        self.isImage = isImage
    }
    
    var body: some View {
        HStack(alignment: isImage ? .center : .firstTextBaseline) {
            Text(title)
                .foregroundColor(colorScheme == .dark ? .white : .gray)
                .frame(width: 140, alignment: .leading)
                .offset(y: isImage ? 1 : 0)
            
            content()
            
            Spacer()
        }
    }
}

#Preview {
    let mockOrder = Order(
        id: "123456",
        userId: "user123",
        fullName: "John Doe",
        phoneNumber: "123-456-7890",
        address: "3 Newbridge Court, Chino Hills, CA 91709, United States",
        note: "Deliver before 5 PM",
        status: .completed,
        payable: 133.0,
        totalDiscount: 10.0,
        paymentMethod: .visa,
        shippingMethod: .ShopeeExpress,
        createdDate: Date()
    )
    
    return OrderInfoView(order: mockOrder)
}
