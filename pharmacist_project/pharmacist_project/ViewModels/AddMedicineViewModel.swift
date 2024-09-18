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

import Foundation
import SwiftUI
import Firebase
import FirebaseStorage
import PhotosUI

import Firebase
import FirebaseStorage
import PhotosUI

class AddMedicineViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var price: Double = 0.0
    @Published var priceDiscount: Double = 0.0
    @Published var availableQuantity: Int = 0
    @Published var description: String = ""
    @Published var ingredients: String = ""
    @Published var supplement: String = ""
    @Published var note: String = ""
    @Published var sideEffect: String = ""
    @Published var dosage: String = ""
    @Published var supplier: String = ""
    @Published var images: [String] = [""]
    @Published var category: Category = .vitamin
    @Published var selectedImageItems: [PhotosPickerItem] = []
    @Published var selectedImages: [UIImage] = []  // For storing picked images
    private var imageUploadURLs: [String] = []
    @Published var useImageURLs: Bool = true  // Track whether to use URLs or uploaded images
    @Published var imageUploadSelectedTabIndex: Int = 0
    
    var isValid: Bool {
        !name.isEmpty &&
        price > 0 &&
        priceDiscount >= 0 &&
        availableQuantity >= 0 &&
        !description.isEmpty &&
        !ingredients.isEmpty &&
        !dosage.isEmpty &&
        !supplier.isEmpty &&
        ((imageUploadSelectedTabIndex == 0 && !selectedImages.isEmpty) 
         || (imageUploadSelectedTabIndex == 1 && !images.filter { !$0.isEmpty }.isEmpty))
    }
    
    func addImage() {
        guard images.count < 5 else { return }
        images.append("")
    }
    
    func removeImage(at index: Int) {
        images.remove(at: index)
    }
    
    // Upload selected images to Firebase Storage when user presses "Save"
    private func uploadSelectedImages() async throws -> [String] {
        var uploadedURLs: [String] = []
        for image in selectedImages {
            if let url = try await uploadImageToStorage(image: image) {
                uploadedURLs.append(url)
            }
        }
        return uploadedURLs
    }
    
    private func uploadImageToStorage(image: UIImage) async throws -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return nil }
        let imageName = UUID().uuidString
        let storageRef = Storage.storage().reference().child("images/\(UUID().uuidString)_\(imageName).jpg")
        
        let _ = try await storageRef.putDataAsync(imageData, metadata: nil)
        let downloadURL = try await storageRef.downloadURL()
        return downloadURL.absoluteString
    }
    
    // Save Medicine and decide whether to use image URLs or uploaded images
    func saveMedicine() async throws {
        var imageUrls: [String] = []

        if imageUploadSelectedTabIndex == 1 {
            imageUrls = images.filter { !$0.isEmpty }
        } else {
            imageUrls = try await self.uploadSelectedImages()
        }
        
        let newMedicine = Medicine(
            name: name,
            price: price,
            priceDiscount: priceDiscount,
            availableQuantity: availableQuantity,
            description: description,
            ingredients: ingredients,
            supplement: supplement,
            note: note,
            sideEffect: sideEffect,
            dosage: dosage,
            supplier: supplier,
            images: imageUrls,
            category: category,
            pharmacyId: nil,
            createdDate: Date()
        )
        
        do {
            try await MedicineService.shared.createDocument(newMedicine)
            print("Medicine saved successfully")
        } catch {
            print("Error saving medicine: \(error.localizedDescription)")
        }
    }
}
