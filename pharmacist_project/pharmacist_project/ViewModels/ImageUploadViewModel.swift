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
import Photos
import FirebaseStorage
import UIKit

class ImageUploadViewModel: ObservableObject {
    @Published var image: UIImage?
    private var storage = Storage.storage().reference()
    @Published var imagePickingButtonState: ButtonState = .active
    @Published var uploadButtonState: ButtonState = .active
    
    func uploadImage(completion: @escaping (Result<URL, Error>) -> Void) {
        guard let imageData = image?.jpegData(compressionQuality: 0.4) else {
            return
        }
        
        // Disable image picking and show loading for upload button
        imagePickingButtonState = .disabled
        uploadButtonState = .loading
        
        let storageRef = storage.child("images/\(UUID().uuidString).jpg")
        
        storageRef.putData(imageData, metadata: nil) { [weak self] metadata, error in
            guard let self = self else { return }
            
            // Handle error
            if let error = error {
                // Update button states on failure
                DispatchQueue.main.async {
                    self.imagePickingButtonState = .active
                    self.uploadButtonState = .active
                }
                completion(.failure(error))
                return
            }
            
            // Retrieve the download URL after successful upload
            storageRef.downloadURL { url, error in
                DispatchQueue.main.async {
                    if let url = url {
                        // Success, change the button states
                        self.imagePickingButtonState = .active
                        self.uploadButtonState = .active
                        completion(.success(url))
                    } else if let error = error {
                        // Failure, change the button states
                        self.imagePickingButtonState = .active
                        self.uploadButtonState = .active
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
