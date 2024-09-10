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
            VStack(spacing: 5) {
                ForEach(viewModel.filteredMedicines) { medicine in
                    HorizontalProductItemCardView(medicine: medicine)
                        .frame(maxWidth: .infinity)
                        .padding() 
                }
            }
        }
        .navigationTitle(title)
        .onAppear {
            if let category = selectedCategory {
                viewModel.handleViewAll(for: category)
            } else if let filter = filterType {
                viewModel.handleViewAll(for: filter)
            }
        }
    }
}

