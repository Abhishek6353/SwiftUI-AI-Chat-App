//
//  UserService.swift
//  SwiftUI-AI-Chat-App
//
//  Created by Apple on 04/09/25.
//

import Foundation
import FirebaseFirestore

struct AppUser: Codable {
    let uid: String
    let name: String
    let email: String
    let createdAt: Date?
    let updatedAt: Date?
}

final class UserService {
    private let db = Firestore.firestore()
    
    // MARK: - Save User Data
    func saveUserProfile(uid: String, name: String, email: String) async throws {
        try await db.collection("users").document(uid).setData([
            "uid": uid,
            "name": name,
            "email": email,
            "createdAt": FieldValue.serverTimestamp(),
            "updatedAt": FieldValue.serverTimestamp()
        ])
    }
    
    // MARK: - Fetch User Data
    func fetchUserProfile(uid: String) async throws -> AppUser? {
        let document = try await db.collection("users").document(uid).getDocument()
        return try document.data(as: AppUser.self)
    }
}
