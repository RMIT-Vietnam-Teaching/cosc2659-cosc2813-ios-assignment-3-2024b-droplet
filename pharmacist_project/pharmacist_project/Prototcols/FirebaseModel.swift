//
//  FirebaseModel.swift
//  pharmacist_project
//
//  Created by Thinh Ngo on 7/9/24.
//

import Foundation

protocol FirebaseModel: Codable, Identifiable {
    var id: String { get }
}
