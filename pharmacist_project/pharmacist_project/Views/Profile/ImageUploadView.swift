/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 3
  Author: Ngo Ngoc Thinh
  ID: s3879364
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

struct ImageUploadView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @ObservedObject var uploadManager = ImageUploadViewModel()
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    
    var body: some View {
        VStack {
            if let image = uploadManager.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }
            
            LoadingButton(title: "Pick image", state: $uploadManager.imagePickingButtonState, style: .fill, backgroundColor: Color.blue, foregroundColor: .white) {
                showingImagePicker = true
            }
            
            if let _ = uploadManager.image {
                LoadingButton(title: "Save to Cloud", state: $uploadManager.uploadButtonState, style: .fill, backgroundColor: Color.green, foregroundColor: .white) {
                    uploadManager.uploadImage { result in
                        switch result {
                        case .success(let url):
                            print("Uploaded successfully: \(url)")
                            
                            userProfileViewModel.updateUser(photoURL: url)
                            
                            dismiss()
                        case .failure(let error):
                            print("Upload failed: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
        .padding()
        .padding(.horizontal)
        .navigationTitle("Upload avatar")
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePickerView(image: $inputImage)
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        uploadManager.image = inputImage
    }
}

#Preview {
    ImageUploadView(userProfileViewModel: UserProfileViewModel())
}
