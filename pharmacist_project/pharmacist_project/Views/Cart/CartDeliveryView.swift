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

struct CartDeliveryView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = CartDeliveryViewModel()
    @State private var isShouldPopbackAfterPayment = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Progress indicators
                    HStack(spacing: 0) {
                        ProgressBar(steps: ["Delivery", "Address"], currentStep: 0)
                    }
                    
                    if !viewModel.cartItems.isEmpty {
                        // Delivery date
                        HStack {
                            Image(systemName: "truck.box")
                            Text("Delivery by \(Date().addingTimeInterval(7*24*60*60).formatted(date: .abbreviated, time: .omitted))")
                        }
                        .font(.subheadline)
                        .padding(.horizontal)
                        
                        // Cart items
                        ForEach($viewModel.cartItems, id: \.id) { $item in
                            CartItemCardView(cartItem: $item).environmentObject(viewModel)
                        }
                        
                        // Payment and Shipping methods
                        VStack(spacing: 10) {
                            PaymentMethodPicker(selectedMethod: $viewModel.selectedPaymentMethod)
                            ShippingMethodPicker(selectedMethod: $viewModel.selectedShippingMethod)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        
                        // Order Summary
                        OrderSummaryView(viewModel: viewModel)
                    } else {
                        Text("Your cart is empty.")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
            }
            .background(Color.white)
            .navigationBarTitleDisplayMode(.inline)
        }
        .padding()
        .overlay(
            VStack {
                Spacer()
                NavigationLink(destination: CartAddressView(
                    viewModel: CartAddressViewModel(
                        payableAmount: viewModel.payableAmount,
                        paymentMethod: viewModel.selectedPaymentMethod,
                        shippingMethod: viewModel.selectedShippingMethod,
                        isShouldPopbackAfterPayment: $isShouldPopbackAfterPayment)
                    )
                ) {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.isCartItemEmpty() ? Color.gray : Color(hex: "#FF6F5C"))
                        .foregroundColor(.white)
                        .cornerRadius(6)
                }
                .padding()
                // Disable the "Continue" button if cart is empty
                .disabled(viewModel.isCartItemEmpty())
            }
        )
        .navigationTitle("Shopping cart")
        .task {
            await viewModel.loadCartItems()
        }
        .onChange(of: isShouldPopbackAfterPayment) { newValue in
            if newValue {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct PaymentMethodPicker: View {
    @Binding var selectedMethod: PaymentMethod
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Payment Method")
                .font(.headline)
            
            HStack(spacing: 10) {
                ForEach(PaymentMethod.allCases, id: \.self) { method in
                    Button(action: {
                        selectedMethod = method
                    }) {
                        Text(method.toString)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(selectedMethod == method ? Color(hex: "2EB5FA") : Color.gray.opacity(0.2))
                            .foregroundColor(selectedMethod == method ? .white : .black)
                            .cornerRadius(8)
                    }
                }
            }
        }
    }
}

struct ShippingMethodPicker: View {
    @Binding var selectedMethod: ShippingMethod
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Shipping Method")
                .font(.headline)
            
            HStack(spacing: 10) {
                ForEach(ShippingMethod.allCases, id: \.self) { method in
                    Button(action: {
                        selectedMethod = method
                    }) {
                        VStack {
                            Text(method.toString)
                            Text("₫\(Int(method.fee))")
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(selectedMethod == method ? Color(hex: "2EB5FA") : Color.gray.opacity(0.2))
                        .foregroundColor(selectedMethod == method ? .white : .black)
                        .cornerRadius(8)
                    }
                }
            }
        }
    }
}

struct OrderSummaryView: View {
    @ObservedObject var viewModel: CartDeliveryViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Order Summary (\(viewModel.cartItems.count) items)")
                .font(.headline)
            
            HStack {
                Text("Total MRP")
                Spacer()
                Text(viewModel.totalMRP.formatAsCurrency())
            }
            
            HStack {
                Text("Shipping Charges")
                Spacer()
                Text(viewModel.selectedShippingMethod.fee.formatAsCurrency())
            }
            
            HStack {
                Text("Total Discount")
                Spacer()
                Text("-\(viewModel.totalDiscount.formatAsCurrency())")
            }
            
            HStack {
                Text("Payable Amount")
                    .fontWeight(.bold)
                Spacer()
                Text(viewModel.payableAmount.formatAsCurrency())
                    .fontWeight(.bold)
            }
            Spacer()
            Spacer()
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(6)
    }
}

#Preview {
    CartDeliveryView()
}
