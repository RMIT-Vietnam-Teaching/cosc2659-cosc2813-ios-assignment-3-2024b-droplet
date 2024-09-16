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

struct AddMedicineView: View {
    @StateObject private var viewModel = AddMedicineViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showAlert = false
    
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
                
                Section(header: Text("Images (Max 5)")) {
                    ForEach(viewModel.images.indices, id: \.self) { index in
                        TextField("Image URL", text: $viewModel.images[index])
                    }
                    if viewModel.images.count < 5 {
                        Button("Add Image") {
                            viewModel.addImage()
                        }
                    }
                }
            }
            .navigationTitle("Add New Medicine")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if viewModel.isValid {
                            Task {
                                await viewModel.saveMedicine()
                                dismiss()
                            }
                        } else {
                            showAlert = true
                        }
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Incomplete Information"),
                    message: Text("Please fill in all required fields before saving."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

#Preview {
    AddMedicineView()
}
