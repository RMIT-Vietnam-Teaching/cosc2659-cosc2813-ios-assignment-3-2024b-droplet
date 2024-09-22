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
import PopupView

struct CartAddressView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: CartAddressViewModel
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isProcessingPayment {
                    ProgressView("Processing payment...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
                        .padding()
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            ProgressBar(steps: ["Delivery", "Address"], currentStep: 1)
                            
                            VStack(alignment: .leading) {
                                Text("Full Name*")
                                    .font(.headline)
                                    .foregroundColor(colorScheme == .dark ? .white : .primary)
                                TextField("Enter your fullname", text: $viewModel.fullName)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading) {
                                Text("Phone Number*")
                                    .font(.headline)
                                    .foregroundColor(colorScheme == .dark ? .white : .primary)
                                TextField("Enter your phone number", text: $viewModel.phoneNumber)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.phonePad)
                            }
                            
                            VStack(alignment: .leading) {
                                Text("Address*")
                                    .font(.headline)
                                    .foregroundColor(colorScheme == .dark ? .white : .primary)
                                TextField("Please add your full address", text: $viewModel.address)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading) {
                                Text("Note (Optional)")
                                    .font(.headline)
                                    .foregroundColor(colorScheme == .dark ? .white : .primary)
                                TextField("Add a note", text: $viewModel.note)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                        }
                        .padding()
                    }
                    .background(colorScheme == .dark ? Color.black : Color.white)
                    .alert(isPresented: $viewModel.showAlert) {
                        Alert(title: Text("Alert"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
                    }
                }
            }
//            .navigationTitle("Receiver information")
            .overlay(
                VStack {
                    Spacer()
                    if !viewModel.isProcessingPayment {
                        Button(action: {
                            Task {
                                try await viewModel.proceedToPayment()
                            }
                        }) {
                            Text("Confirm & Proceed")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(hex: "#FF6F5C"))
                                .foregroundColor(.white)
                                .cornerRadius(6)
                        }
                        .padding()
                    }
                }
            )
            .onAppear {
                Task {
                    await viewModel.loadUserData()
                }
            }
            
            // MARK: order placed success popup
            .popup(isPresented: $viewModel.isShowOrderPlacedSuccessPopUp) {
                GradientBackgroundPopup(title: "") {
                    VStack(spacing: 24) {
                        Image("order-placed")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 160)
                        
                        Text("Order placed")
                            .font(.title2)
                            .foregroundColor(.white)
                        
                        Spacer()
                        Spacer()
                        
                        LoadingButton(title: "Back Home", state: .constant(.active), style: .fill) {
                            withAnimation {
                                viewModel.isShowOrderPlacedSuccessPopUp = false
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top)
                    .padding(.top)
                }
                .navigationBarBackButtonHidden(true)
            } customize: {
                $0
                    .closeOnTap(false)
                    .closeOnTapOutside(false)
            }
        }
    }
}

#Preview {
    CartAddressView(viewModel: CartAddressViewModel(payableAmount: 100000, paymentMethod: .visa, shippingMethod: .NinjaVan, isShouldPopbackAfterPayment: .constant(false)))
}
