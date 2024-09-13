//
//  ImageUploadViewModel.swift
//  pharmacist_project
//
//  Created by Thinh Ngo on 7/9/24.
//

import Foundation
import Photos
import FirebaseStorage
import UIKit

class ImageUploadViewModel: ObservableObject {
    @Published var image: UIImage?
    private var storage = Storage.storage().reference()
    
    func uploadImage(completion: @escaping (Result<URL, Error>) -> Void) {
        guard let imageData = image?.jpegData(compressionQuality: 0.4) else {
            return
        }
        print("uploading2")
        let storageRef = storage.child("images/\(UUID().uuidString).jpg")
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            storageRef.downloadURL { url, error in
                if let url = url {
                    completion(.success(url))
                } else if let error = error {
                    completion(.failure(error))
                }
            }
        }
    }
}
