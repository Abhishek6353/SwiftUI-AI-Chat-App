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
}

final class UserService {
    private let db = Firestore.firestore()
    
    // MARK: - Save User Data
    func saveUserProfile(uid: String, name: String, email: String) async throws {
        let user = AppUser(uid: uid, name: name, email: email)
        try db.collection("users").document(uid).setData(from: user)
    }
    
    
    // MARK: - Fetch User Data
    func fetchUserProfile(uid: String) async throws -> AppUser? {
        let document = try await db.collection("users").document(uid).getDocument()
        return try document.data(as: AppUser.self)
    }
}
