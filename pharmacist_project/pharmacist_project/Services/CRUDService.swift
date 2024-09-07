//
//  CRUDService.swift
//  pharmacist_project
//
//  Created by Thinh Ngo on 7/9/24.
//

import Foundation
import FirebaseFirestore

class CRUDService<T: FirebaseModel> {
    
    var collectionName: String {
        fatalError("Must implemented in sub-class")
    }
    
    var collection: CollectionReference {
        Firestore.firestore().collection(collectionName)
    }
    
    func document(_ id: String) -> DocumentReference {
        collection.document(id)
    }
    
    func createDocument(_ model: T) async throws {
        try collection.document(model.id).setData(from: model, merge: false)
    }
    
    func updateDocument(_ model: T) async throws {
        try collection.document(model.id).setData(from: model, merge: true)
    }
    
    func getDocument(_ documentId: String) async throws -> T {
        try await document(documentId).getDocument(as: T.self)
    }
    
    func updateDocumentFields(_ documentId: String, fields: [String: Any]) async throws {
        try await document(documentId).updateData(fields)
    }
    
    func deleteDocument(_ model: T) async throws {
        try await collection.document(model.id).delete()
    }
    
    func isDocumentExist(_ documentId: String) async -> Bool {
        do {
            var document = try await document(documentId).getDocument()
            return document.exists
        } catch {
            return false
        }
    }
}

extension CRUDService {
    static func generateUniqueId(collection: CollectionReference) -> String {
        return collection.document().documentID
    }
}
