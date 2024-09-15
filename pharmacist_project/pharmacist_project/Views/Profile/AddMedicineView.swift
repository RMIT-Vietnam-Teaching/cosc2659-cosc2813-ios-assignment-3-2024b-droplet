//
//  AddMedicineView.swift
//  pharmacist_project
//
//  Created by Dinh Le Hong Tin on 15/9/24.
//

import SwiftUI

struct AddMedicineView: View {
    @StateObject private var viewModel = AddMedicineViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Basic Information")) {
                    TextField("Name", text: $viewModel.name)
                    TextField("Price", value: $viewModel.price, format: .currency(code: "VND"))
                        .keyboardType(.decimalPad)
                    TextField("Discounted Price", value: $viewModel.priceDiscount, format: .currency(code: "VND"))
                        .keyboardType(.decimalPad)
                    TextField("Available Quantity", value: $viewModel.availableQuantity, format: .number)
                        .keyboardType(.numberPad)
                }
                
                Section(header: Text("Details")) {
                    TextField("Description", text: $viewModel.description)
                    TextField("Ingredients", text: $viewModel.ingredients)
                    TextField("Supplement", text: $viewModel.supplement)
                    TextField("Note", text: $viewModel.note)
                    TextField("Side Effects", text: $viewModel.sideEffect)
                    TextField("Dosage", text: $viewModel.dosage)
                    TextField("Supplier", text: $viewModel.supplier)
                }
                
                Section(header: Text("Category")) {
                    Picker("Category", selection: $viewModel.category) {
                        ForEach(Category.allCases, id: \.self) { category in
                            Text(category.rawValue.capitalized).tag(category)
                        }
                    }
                }
                
                Section(header: Text("Images")) {
                    ForEach(viewModel.images.indices, id: \.self) { index in
                        TextField("Image URL", text: $viewModel.images[index])
                    }
                    Button("Add Image") {
                        viewModel.images.append("")
                    }
                }
            }
            .navigationTitle("Add New Medicine")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        Task {
                            await viewModel.saveMedicine()
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    AddMedicineView()
}
