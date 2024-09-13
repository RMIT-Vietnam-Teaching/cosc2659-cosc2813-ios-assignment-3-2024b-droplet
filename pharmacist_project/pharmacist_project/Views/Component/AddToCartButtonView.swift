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
    @State private var isAdding: Bool = false
    @State private var showError: Bool = false
    let medicine: Medicine
    @State private var errorMessage: String = ""

    
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
            errorMessage = ""
            
            Task {
                do {
                    guard let user = await AuthenticationService.shared.getAuthenticatedUser() else {
                        throw NSError(domain: "Authentication", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
                    }
                    
                    let cart = try await CartService.shared.getUserCart(userId: user.id)
                    
                    let cartItem = CartItem(
                        cartId: cart.id,
                        medicineId: medicine.id,
                        quantity: 1,
                        createdDate: Date()
                    )
                    
                    await viewModel.addToCart(cartItem)
                    
                    if let error = viewModel.error {
                        throw error
                    }
                    
                    print("Item added to cart successfully")
                } catch {
                    errorMessage = error.localizedDescription
                    showError = true
                }
                
                isAdding = false
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
