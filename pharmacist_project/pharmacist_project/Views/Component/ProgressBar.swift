//
//  ProgressBar.swift
//  pharmacist_project
//
//  Created by Dinh Le Hong Tin on 13/9/24.
//

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
