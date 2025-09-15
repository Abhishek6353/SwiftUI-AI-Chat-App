//
//  FirebaseService.swift
//  SwiftUI-AI-Chat-App
//
//  Created by Apple on 04/09/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class FirebaseService {
    private let db = Firestore.firestore()
    
    
    // MARK: - Sessions
    func createSession(title: String? = nil, model: String = "gpt-3.5") async throws -> String {
        guard let uid = Auth.auth().currentUser?.uid else { throw NSError(domain: "Auth", code: 401) }
        let sessionRef = db.collection("sessions").document()
        let sessionID = sessionRef.documentID
        
        let data: [String: Any] = [
            "ownerId": uid,
            "title": title ?? "New Chat",
            "createdAt": FieldValue.serverTimestamp(),
            "updatedAt": FieldValue.serverTimestamp(),
            "messageCount": 0,
            "approxTotalTokens": 0,
            "model": model,
            "status": "active"
        ]
        
        try await sessionRef.setData(data)
        return sessionID
    }
    
    
}


