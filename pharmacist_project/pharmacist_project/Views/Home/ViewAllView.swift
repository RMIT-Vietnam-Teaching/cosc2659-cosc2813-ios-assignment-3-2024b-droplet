//
//  ViewAllView.swift
//  pharmacist_project
//
//  Created by Leon Do on 10/9/24.
//

import SwiftUI

struct ViewAllView: View {
    @ObservedObject var viewModel: HomeViewModel
    var filterType: HomeFilter? = nil
    var selectedCategory: Category? = nil
    var title: String
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                let filteredMedicines: [Medicine] = {
                    if let category = selectedCategory {
                        return viewModel.medicines.filter { $0.category == category }
                    } else if let filter = filterType {
                        switch filter {
                        case .flashSale:
                            return viewModel.medicines.filter { $0.priceDiscount != nil && $0.priceDiscount! < $0.price! }
                        case .newReleases:
                            return viewModel.medicines.filter {
                                if let createdDate = $0.createdDate {
                                    return Calendar.current.isDateInLast30Days(createdDate)
                                }
                                return false
                            }
                        }
                    }
                    return []
                }()
                
                if filteredMedicines.isEmpty {
                    Text("No items available.")
                        .font(.headline)
                        .padding()
                } else {
                    ForEach(filteredMedicines) { medicine in
                        HorizontalProductItemCardView(medicine: medicine)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal)
                    }
                }
            }
        }
        .navigationTitle(title)
        .onAppear {
            viewModel.filterMedicines()
        }
    }
}
