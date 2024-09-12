import SwiftUI

struct OrderInfoView: View {
    let order: Order
    
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
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct InfoRow<Content: View>: View {
    let title: String
    let content: () -> Content
    let isImage: Bool
    
    init(title: String, isImage: Bool = false, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
        self.isImage = isImage
    }
    
    var body: some View {
        HStack(alignment: isImage ? .center : .firstTextBaseline) {
            Text(title)
                .foregroundColor(.gray)
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
