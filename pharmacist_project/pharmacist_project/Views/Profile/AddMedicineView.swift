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
import PhotosUI

struct AddMedicineView: View {
    @StateObject private var viewModel = AddMedicineViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showAlert = false
    @State private var isSaving = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Basic Information")) {
                    TextField("Name", text: $viewModel.name)
                    
                    // Price
                    ZStack(alignment: .leading) {
                        if viewModel.price == 0.0 {
                            Text("Price")
                                .foregroundColor(.gray)
                                .padding(.leading)
                                .padding(.leading)
                                .padding(.leading)
                        }
                        TextField("", value: $viewModel.price, format: .currency(code: "VND"))
                            .keyboardType(.decimalPad)
                    }
                    
                    // Discounted Price
                    ZStack(alignment: .leading) {
                        if viewModel.priceDiscount == 0.0 {
                            Text("Discounted Price")
                                .foregroundColor(.gray)
                                .padding(.leading)
                                .padding(.leading)
                                .padding(.leading)
                        }
                        TextField("", value: $viewModel.priceDiscount, format: .currency(code: "VND"))
                            .keyboardType(.decimalPad)
                    }

                    // Available Quantity
                    ZStack(alignment: .leading) {
                        if viewModel.availableQuantity == 0 {
                            Text("Available Quantity")
                                .foregroundColor(.gray)
                                .padding(.leading)
                                .padding(.leading)
                                .padding(.leading)
                        }
                        TextField("", value: $viewModel.availableQuantity, format: .number)
                            .keyboardType(.numberPad)
                    }
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
                
                // TabView to switch between URL and image upload
                Section(header: Text("Images (Max 5)")) {
                    TabView(selection: $viewModel.imageUploadSelectedTabIndex) {
                        // Upload images by uploading
                        VStack {
                            PhotosPicker(
                                selection: $viewModel.selectedImageItems,
                                maxSelectionCount: 5,
                                matching: .images
                            ) {
                                Text("Pick Images from Library")
                            }
                            
                            // Display selected images in a scrollable view
                            if !viewModel.selectedImages.isEmpty {
                                ScrollView(.horizontal) {
                                    HStack {
                                        ForEach(viewModel.selectedImages, id: \.self) { image in
                                            Image(uiImage: image)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 100, height: 100)
                                                .cornerRadius(10)
                                        }
                                    }
                                }
                                .frame(height: 100)
                            }
                        }
                        .tag(0)
                        .tabItem {
                            Label("Upload", systemImage: "photo")
                        }
                        .padding(.bottom, 24)
                        
                        // Upload images by input URLs
                        VStack {
                            ForEach(viewModel.images.indices, id: \.self) { index in
                                HStack {
                                    TextField("Image URL", text: $viewModel.images[index])
                                    
                                    // Add a delete button for each row
                                    Button(action: {
                                        viewModel.removeImage(at: index)
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                    .padding(.leading, 8) // Add padding between text field and delete button
                                }
                                .padding(.horizontal)
                            }
                            
                            if viewModel.images.count < 5 {
                                Button("Add Image") {
                                    viewModel.addImage()
                                }
                            }
                        }
                        .tag(0)
                        .tabItem {
                            Label("URL", systemImage: "link")
                        }
                        .padding(.bottom, 24)
                    }
                    .frame(minHeight: 240)
                }
            }
            .navigationTitle("Add New Medicine")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !isSaving {
                        Button("Save") {
                            if viewModel.isValid {
                                Task {
                                    isSaving = true
                                    try await viewModel.saveMedicine()
                                    isSaving = false
                                    dismiss()
                                }
                            } else {
                                showAlert = true
                            }
                        }
                    } else {
                        ProgressView()
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
            .onChange(of: viewModel.selectedImageItems) { newItems in
                Task {
                    viewModel.selectedImages = []
                    for imageItem in newItems {
                        if let data = try? await imageItem.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            viewModel.selectedImages.append(uiImage)
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
