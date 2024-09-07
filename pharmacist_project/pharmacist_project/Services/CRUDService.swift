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
            return try await document(documentId).getDocument().exists
        } catch {
            return false
        }
    }
    
    func getAllDocuments() async throws {
//        collection.document().all
    }
    
    func fetchDocuments(filter: (Query) -> Query, limit: Int? = nil, page: Int = 0) async throws -> [T] {
        var query: Query = collection
        
        // Apply filtering, sorting, etc., via the filter closure
        query = filter(query)
        
        // Apply pagination if limit is provided
        if let limit = limit {
            let offset = page * limit
            query = query.limit(to: limit).start(at: [offset])
        }
        
        // Perform the query
        let documents = try await query.getDocuments().documents
        let results: [T] = documents.compactMap { document in
            try? document.data(as: T.self)
        }
        
        return results
    }
    
    func bulkCreate(documents: [T]) async throws {
        let batch = Firestore.firestore().batch()
        
        for document in documents {
            let newDocRef = collection.document(document.id)
            try batch.setData(from: document, forDocument: newDocRef, merge: false)
        }
        
        try await batch.commit()
    }
    
    func bulkDelete(documentIds: [String]) async throws {
        let batch = Firestore.firestore().batch()
        
        documentIds.forEach { id in
            let docRef = collection.document(id)
            batch.deleteDocument(docRef)
        }
        
        try await batch.commit()
    }
}

extension CRUDService {
    static func generateUniqueId(collection: CollectionReference) -> String {
        return collection.document().documentID
    }
}
