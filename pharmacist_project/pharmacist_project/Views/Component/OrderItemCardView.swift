//
//  OrderItemView.swift
//  pharmacy
//
//  Created by Dinh Le Hong Tin on 7/9/24.
//

import SwiftUI

struct OrderItemCardView: View {
    var orderItem: OrderItem
    var medicine: Medicine
    
    var body: some View {
        Button(action: {
            // go to product details
            print("product details")
        }) {
            HStack(alignment: .top, spacing: 12) {
                AsyncImage(url: URL(string: medicine.images[0])) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                            .cornerRadius(8)
                    } else if phase.error != nil {
                        Color.gray.frame(width: 80, height: 80)
                            .cornerRadius(8)
                    } else {
                        ProgressView().frame(width: 80, height: 80)
                            .cornerRadius(8)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(medicine.name!)
                        .font(.subheadline)
                        .lineLimit(2)
                    
                    Text(medicine.description!)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .truncationMode(.tail)
                    
                    HStack(spacing: 12) {
                        HStack {
                            Text("Unit:")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("\(orderItem.quantity!)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        HStack {
                            Text("\(orderItem.pricePerUnitDiscount!.formatAsCurrency())")
                                .font(.headline)
                                .fontWeight(.bold)
                            
                            Text("\(orderItem.pricePerUnit!.formatAsCurrency())")
                                .font(.subheadline)
                                .strikethrough()
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Spacer()
            }
            .frame(height: 100)
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    let mockOrderItem = OrderItem(
        id: "item123",
        orderId: "order123",
        medicineId: "med123",
        quantity: 2,
        pricePerUnit: 599000,
        pricePerUnitDiscount: 499000,
        createdDate: Date()
    )
    
    let mockMedicine = Medicine(
        id: "med123",
        name: "Life Omega-3 Fish Oil 1000mg, 30 Capsules",
        price: 180,
        priceDiscount: 160,
        availableQuantity: 999,
        description: "The Apollo Omega 3 Fish Oil, formally known as Apollo Life Omega-3 Fish Oil 1000 mg, comes in a pack of 30 capsules and provides several health benefits. This product is designed to support the function of various organs including the kidneys, liver, heart, and brain. Apollo Omega 3 contains Omega-3 fatty acids, specifically EPA and DHA. EPA aids in nervous function, blood pressure reduction, and triglyceride lowering. DHA supports memory, focus, vision improvement, brain function, and inflammation reduction. This Apollo Fish Oil is purified to be free from heavy metals. Each softgel delivers 9.02 Kcal of energy and 1.003 g of total fat without any protein, carbohydrates, trans fats, or cholesterol. For usage, adults are advised to take one softgel 1-2 times daily with lukewarm water or as per the instructions of a healthcare practitioner.",
        ingredients: "Fish oil, Food-grade gelatin shell.",
        supplement: "Omega-3 Fatty Acids: Each capsule contains significant amounts of EPA and DHA, which are crucial for:\nEPA: Enhances nervous system function, helps lower blood pressure, and reduces triglyceride levels in the bloodstream.\nDHA: Supports brain function including memory and focus, aids in vision improvement, and helps reduce inflammation.",
        note: "The Apollo Omega 3 Fish Oil targets multiple vital organs - kidneys, liver, heart, and brain. This wide-ranging organ support is due to the high concentration of Omega-3 fatty acids in each capsule.\nThe presence of Eicosapentaenoic Acid (EPA) in the Apollo Fish Oil means it has multiple health benefits. EPA improves nervous function, helps lower high blood pressure and can reduce elevated triglyceride levels in the bloodstream.",
        sideEffect: "No specific side effects were mentioned in the product description. However, common side effects associated with Omega-3 supplements, generally not specific to this product unless experienced, can include:\nFishy aftertaste or breath.\nUpset stomach or loose stools, particularly at high doses.\nPossible interaction with blood-thinning medications, if applicable.",
        dosage: "For adults, take one Apollo Omega 3 Fish Oil softgel 1-2 times a day with lukewarm water.\nThis dosage can be adjusted or modified as directed by a healthcare practitioner.\nEnsure that the softgel is swallowed whole, without chewing or breaking it.",
        supplier: "Apollo Healthco Limited - 19, Bishop Gardens, Raja Annamalaipuram, Chennai - 600028 (Tamil Nadu)",
        images: [
            "https://images.apollo247.in/pub/media/catalog/product/i/m/img_20210108_174942__front__omega-3_fish_oil_4__1.jpg",
            "https://images.apollo247.in/pub/media/catalog/product/i/m/img_20210108_175003__back__omega-3_fish_oil_4_.jpg",
            "https://images.apollo247.in/pub/media/catalog/product/i/m/img_20210108_175032__side__omega-3_fish_oil_4__1.jpg",
            "https://images.apollo247.in/pub/media/catalog/product/A/P/APO0077_4-JULY23_1.jpg",
            "https://images.apollo247.in/pub/media/catalog/product/A/P/APO0077_5-JULY23_1.jpg",
        ],
        category: .vitamin,
        pharmacyId: "1",
        createdDate: Date()
        )
    
    return OrderItemCardView(orderItem: mockOrderItem, medicine: mockMedicine)
}
