//
//  ImageUploadView.swift
//  pharmacist_project
//
//  Created by Thinh Ngo on 7/9/24.
//

import Foundation
import SwiftUI

struct ImageUploadView: View {
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @ObservedObject var uploadManager = ImageUploadViewModel()
    
    var body: some View {
        VStack {
            if let image = uploadManager.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }
            
            Button("Upload Image") {
                showingImagePicker = true
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .clipShape(Capsule())
            
            if let _ = uploadManager.image {
                Button("Save to Cloud") {
                    uploadManager.uploadImage { result in
                        switch result {
                        case .success(let url):
                            print("Uploaded successfully: \(url)")
                        case .failure(let error):
                            print("Upload failed: \(error.localizedDescription)")
                        }
                    }
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.green)
                .clipShape(Capsule())
            }
        }
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
    ImageUploadView()
}
