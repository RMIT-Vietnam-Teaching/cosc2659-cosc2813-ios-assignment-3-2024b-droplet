import SwiftUI

struct OrderInfoView: View {
    let shippingAddress: String
    let paymentMethod: String
    let deliveryMethod: String
    let discount: String
    let totalAmount: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Order information")
                .font(.headline)
                .fontWeight(.regular)
            
            InfoRow(title: "Shipping Address:") { Text(shippingAddress) }
            
            InfoRow(title: "Payment method:", isImage: true) {
                Image(paymentMethod)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 65)
                    .padding(.leading, -27)
            }
            
            InfoRow(title: "Delivery method:") { Text(deliveryMethod) }
            
            InfoRow(title: "Discount:") { Text(discount) }
            
            InfoRow(title: "Total Amount:") { Text(totalAmount) }
        }
        .padding()
        .background(Color.white)
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
    OrderInfoView(
        shippingAddress: "3 Newbridge Court, Chino Hills, CA 91709, United States",
        paymentMethod: "Mastercard",
        deliveryMethod: "FedEx, 3 days, 15$",
        discount: "10%, Personal promo code",
        totalAmount: "133$"
    )
    .previewLayout(.sizeThatFits)
    .padding()
}
