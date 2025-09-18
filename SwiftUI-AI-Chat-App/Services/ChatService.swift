//
//  FirebaseService.swift
//  SwiftUI-AI-Chat-App
//
//  Created by Apple on 04/09/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class ChatService {
    private let db = Firestore.firestore()
    
    
    // MARK: - Sessions
    func createSession(title: String? = nil, model: String = "gemini-2.0-flash") async throws -> String {
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
    
    func fetchSessions() async throws -> [Session] {
        guard let uid = Auth.auth().currentUser?.uid else { throw NSError(domain: "Auth", code: 401) }
        let querySnapshot = try await db.collection("sessions")
            .whereField("ownerId", isEqualTo: uid)
            .order(by: "updatedAt", descending: true)
            .getDocuments()
        let sessions = querySnapshot.documents.compactMap { Session(document: $0) }
        return sessions
    }
    
    /// Observe sessions in real-time for the current user. Returns a listener handle you must retain and remove when done.
    func observeSessions(completion: @escaping ([Session]) -> Void) -> ListenerRegistration? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        let listener = db.collection("sessions")
            .whereField("ownerId", isEqualTo: uid)
            .order(by: "updatedAt", descending: true)
            .addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    completion([])
                    return
                }
                let sessions = snapshot.documents.compactMap { Session(document: $0) }
                completion(sessions)
            }
        return listener
    }
    
    // MARK: - Messages
    func addMessage(to sessionId: String, message: Message) async throws {
        let messagesRef = db.collection("sessions").document(sessionId).collection("messages").document()
        try await messagesRef.setData(message.dictionary)
        
        // Update session metadata
        let sessionRef = db.collection("sessions").document(sessionId)
        try await sessionRef.updateData([
            "updatedAt": FieldValue.serverTimestamp(),
            "lastMessagePreview": message.content,
            "messageCount": FieldValue.increment(Int64(1))
        ])
    }
    
    func fetchMessages(for sessionId: String) async throws -> [Message] {
        let querySnapshot = try await db.collection("sessions").document(sessionId).collection("messages")
            .order(by: "createdAt", descending: false)
            .getDocuments()
        print(querySnapshot.documents)
        let messages = querySnapshot.documents.compactMap { Message(document: $0.data(), id: $0.documentID) }
        return messages
    }
    
    func updateSessionTitle(sessionId: String, title: String) async throws {
        let sessionRef = db.collection("sessions").document(sessionId)
        try await sessionRef.updateData(["title": title, "updatedAt": FieldValue.serverTimestamp()])
    }
}
