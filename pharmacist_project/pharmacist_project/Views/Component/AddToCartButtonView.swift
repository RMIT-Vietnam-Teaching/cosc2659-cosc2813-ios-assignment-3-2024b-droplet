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
    @StateObject private var viewModel: CartDeliveryViewModel
    let medicine: Medicine
    @State private var isAdding: Bool = false
    @State private var showError: Bool = false
    
    init(medicine: Medicine) {
        self.medicine = medicine
        _viewModel = StateObject(wrappedValue: CartDeliveryViewModel())
    }
    
    var body: some View {
        Button(action: {
            addToCart()
        }) {
            if isAdding {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            } else {
                Text("Add to Cart")
                    .fontWeight(.bold)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(isAdding ? Color.gray : Color.orange)
        .foregroundColor(.white)
        .overlay(
            RoundedRectangle(cornerRadius: 0)
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
        )
        .disabled(isAdding)
        .alert(isPresented: $showError) {
            Alert(title: Text("Error"), message: Text(viewModel.error?.localizedDescription ?? "Unknown error occurred"), dismissButton: .default(Text("OK")))
        }
    }
    
    private func addToCart() {
        isAdding = true
        Task {
            await viewModel.addToCart(CartItem(
                cartId: "1",  // This should be replaced with the actual cart ID
                medicineId: medicine.id,
                quantity: 1,
                createdDate: Date()
            ))
            isAdding = false
            if viewModel.error != nil {
                showError = true
            }
        }
    }
}

#Preview {
    AddToCartButtonView(medicine: Medicine(
        id: "1",
        name: "Sample Medicine",
        price: 10.0,
        priceDiscount: 8.0,
        availableQuantity: 100,
        images: [],
        category: .vitamin,
        pharmacyId: "1"
    ))
}
