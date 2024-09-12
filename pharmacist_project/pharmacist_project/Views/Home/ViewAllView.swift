//
//  ViewAllView.swift
//  pharmacist_project
//
//  Created by Leon Do on 10/9/24.
//

import SwiftUI

struct ViewAllView: View {
    @ObservedObject var viewModel: MedicineViewModel
    var filterType: HomeFilter? = nil
    var selectedCategory: Category? = nil
    var title: String
    
    var filteredMedicines: [Medicine] {
        if let category = selectedCategory {
            return viewModel.medicines.filter { $0.category == category }
        } else if let filter = filterType {
            switch filter {
            case .flashSale:
                return viewModel.medicines.filter { $0.priceDiscount != nil }
            case .newReleases:
                return viewModel.medicines.filter {
                    if let createdDate = $0.createdDate {
                        return Calendar.current.isDateInLast30Days(createdDate)
                    }
                    return false
                }
            }
        }
        return viewModel.medicines
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 5) {
                ForEach(filteredMedicines) { medicine in
                    HorizontalProductItemCardView(medicine: medicine)
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                }
            }
        }
        .navigationTitle(title)
    }
}
