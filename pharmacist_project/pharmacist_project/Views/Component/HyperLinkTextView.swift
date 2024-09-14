//
//  HyperLinkTextView.swift
//  pharmacist_project
//
//  Created by Thinh Ngo on 14/9/24.
//

import SwiftUI
import WrappingHStack

struct HyperLinkTextView: View {
    var responses: [HyperLinkResponse]
    @State private var selectedMedicineViewModel: MedicineDetailViewModel? = nil
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil

    var body: some View {
        VStack {
            WrappingHStack(0..<responses.count, id: \.self, spacing: .constant(0)) { index in
                let response = responses[index]
                if response.type == .hyperLink {
                    // Display hyperlink using a Button to trigger async loading
                    Button(action: {
                        loadMedicineDetailViewModel(medicineId: response.medicineId)
                    }) {
                        Text("\(response.rawText)")
                            .foregroundColor(.blue) // Display as a hyperlink
                            .underline() // Underline to show it's clickable
                            .lineLimit(1) // Limit to one line
                            .truncationMode(.tail) // Show "..." at the end if truncated
                            .frame(maxWidth: UIScreen.main.bounds.width * 0.5) // Set maximum width
                    }
                } else {
                    // Display raw text
                    Text(response.rawText)
                        .lineLimit(nil) // Allow unlimited lines
                        .fixedSize(horizontal: false, vertical: true) // Prevent truncation
                }
            }
        }
        .alert(isPresented: .constant(errorMessage != nil)) {
            Alert(title: Text("Error"), message: Text(errorMessage ?? ""), dismissButton: .default(Text("OK")))
        }
        .navigationDestination(isPresented: .constant(selectedMedicineViewModel != nil)) {
            if let viewModel = selectedMedicineViewModel {
                MedicineDetailView(viewModel: viewModel)
            }
        }
    }
    
    // Asynchronous function to load the medicine detail view model
    func loadMedicineDetailViewModel(medicineId: String) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let medicine = try await MedicineService.shared.getDocument(medicineId)
                let pharmacy = try await PharmacyService.shared.getDocument(medicine.pharmacyId!)
                
                let viewModel = MedicineDetailViewModel(medicine: medicine)
                viewModel.medicine = medicine
                viewModel.pharmacy = pharmacy
                
                selectedMedicineViewModel = viewModel
                isLoading = false
            } catch {
                errorMessage = "Failed to load medicine details: \(error.localizedDescription)"
                isLoading = false
            }
        }
    }
}


// Preview provider for SwiftUI preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let responses = [
            HyperLinkResponse(type: .text, rawText: "Here is some text before the link. Here is some text before the link, Here is some text before the link", medicineId: ""),
            HyperLinkResponse(type: .hyperLink, rawText: "Omega 3", medicineId: "1"),
            HyperLinkResponse(type: .text, rawText: " and here is some text after the link. ", medicineId: ""),
            HyperLinkResponse(type: .hyperLink, rawText: "Omega 5", medicineId: "2")
        ]

        return NavigationStack {
            HyperLinkTextView(responses: responses)
        }
    }
}
