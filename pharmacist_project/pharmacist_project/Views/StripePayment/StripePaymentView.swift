///*
//  RMIT University Vietnam
//  Course: COSC2659 iOS Development
//  Semester: 2024B
//  Assessment: Assignment 3
//  Author: Long Hoang Pham
//  ID: s3938007
//  Created  date: 05/09/2024
//  Last modified: 16/09/2024
//  Acknowledgement:
//     https://rmit.instructure.com/courses/138616/modules/items/6274581
//     https://rmit.instructure.com/courses/138616/modules/items/6274582
//     https://rmit.instructure.com/courses/138616/modules/items/6274583
//     https://rmit.instructure.com/courses/138616/modules/items/6274584
//     https://rmit.instructure.com/courses/138616/modules/items/6274585
//     https://rmit.instructure.com/courses/138616/modules/items/6274586
//     https://rmit.instructure.com/courses/138616/modules/items/6274588
//     https://rmit.instructure.com/courses/138616/modules/items/6274589
//     https://rmit.instructure.com/courses/138616/modules/items/6274590
//     https://rmit.instructure.com/courses/138616/modules/items/6274591
//     https://rmit.instructure.com/courses/138616/modules/items/6274592
//     https://developer.apple.com/documentation/swift/
//     https://developer.apple.com/documentation/swiftui/
//*/
//
//import SwiftUI
//
//struct StripePaymentView: View {
//    @StateObject var paymentViewModel = StripePaymentViewModel()
//    @State var amount: Int
//    var actionSuccess: () -> Void
//    var actionFailed: () -> Void
//
//
//    var body: some View {
//        VStack {
//            Text("Complete Your Payment")
//
//            Button(action: {
//                paymentViewModel.initiatePayment(amount: amount)
//            }) {
//                Text("Proceed to payment")
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
//            .disabled(paymentViewModel.paymentInProgress)
//            .padding()
//
//        }
//        .padding()
//    }
//}
//
//#Preview{
//    StripePaymentView(amount: 19500, actionSuccess: {}, actionFailed: {})
//}
