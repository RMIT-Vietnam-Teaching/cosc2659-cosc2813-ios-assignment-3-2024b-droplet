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

struct ProgressBar: View {
    let steps: [String]
    let currentStep: Int
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<steps.count, id: \.self) { index in
                VStack(alignment: .center, spacing: 8) {
                    ZStack {
                        HStack(spacing: 0) {
                            if index > 0 {
                                Rectangle()
                                    .fill(index <= currentStep ? Color(hex: "2EB5FA") : Color.gray.opacity(0.3))
                                    .frame(height: 1)
                            }
                            if index < steps.count - 1 {
                                Rectangle()
                                    .fill(index < currentStep ? Color(hex: "2EB5FA") : Color.gray.opacity(0.3))
                                    .frame(height: 1)
                            }
                        }
                        Circle()
                            .stroke(index <= currentStep ? Color(hex: "2EB5FA") : Color.gray.opacity(0.3), lineWidth: 1)
                            .frame(width: 24, height: 24)
                        if index <= currentStep {
                            Circle()
                                .fill(Color(hex: "2EB5FA"))
                                .frame(width: 12, height: 12)
                        }
                    }
                    .frame(height: 24)
                    
                    Text(steps[index])
                        .font(.caption)
                        .foregroundColor(index <= currentStep ? Color(hex: "2EB5FA") : .gray)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
    }
}

#Preview {
    ProgressBar(steps: ["Delivery", "Address", "Payment", "Place Order"], currentStep: 1)
}
