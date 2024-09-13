//
//  CartDeliveryView.swift
//  pharmacist_project
//
//  Created by Dinh Le Hong Tin on 10/9/24.
//

import SwiftUI

struct CartDeliveryView: View {
    @StateObject private var viewModel = CartDeliveryViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Progress indicators
                    HStack(spacing: 0) {
                        ProgressBar(steps: ["Delivery", "Address", "Payment", "Place Order"], currentStep: 0)
                    }
                    
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
                    // Payment and Shipping methods
                    VStack(spacing: 10) {
                        PaymentMethodPicker(selectedMethod: $viewModel.selectedPaymentMethod)
                        ShippingMethodPicker(selectedMethod: $viewModel.selectedShippingMethod)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    
                    // Order Summary
//                    VStack(alignment: .leading, spacing: 10) {
//                        Text("Order Summary (\(viewModel.cartItems.count) items)")
//                            .font(.headline)
//                        
//                        HStack {
//                            Text("Total MRP")
//                            Spacer()
//                            Text(viewModel.totalMRP.formatAsCurrency())
//                        }
//                        
//                        HStack {
//                            Text("Shipping Charges")
//                            Spacer()
//                            Text("Free")
//                        }
//                        
//                        HStack {
//                            Text("Total Discount")
//                            Spacer()
//                            Text("-\(viewModel.totalDiscount.formatAsCurrency())")
//                        }
//                        
//                        HStack {
//                            Text("Payable Amount")
//                                .fontWeight(.bold)
//                            Spacer()
//                            Text(viewModel.payableAmount.formatAsCurrency())
//                                .fontWeight(.bold)
//                        }
//                    }
//                    .padding()
//                    .background(Color.white)
//                    .cornerRadius(6)
                    
                    OrderSummaryView(viewModel: viewModel)

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
                NavigationLink(destination: CartAddressView()) {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#FF6F5C"))
                        .foregroundColor(.white)
                        .cornerRadius(6)
                }
                .padding()
            }
        )
        .task {
            await viewModel.loadCartItems()
        }
    }
}

struct PaymentMethodPicker: View {
    @Binding var selectedMethod: PaymentMethod
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
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
        VStack(alignment: .leading, spacing: 10) {
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
        }
        .padding()
        .background(Color.white)
        .cornerRadius(6)
    }
}

#Preview {
    CartDeliveryView()
}
