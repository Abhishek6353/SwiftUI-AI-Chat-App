//
//  Models.swift
//  SwiftUI-AI-Chat-App
//
//  Created by Apple on 02/09/25.
//

import Foundation
import FirebaseFirestore

struct Message: Identifiable {
    var id = UUID()
    let content: String
    let isUser: Bool   // true = user, false = AI
}

extension Message {
    init?(document: [String: Any], id: String) {
        guard let content = document["content"] as? String,
              let isUser = document["isUser"] as? Bool else { return nil }
        self.content = content
        self.isUser = isUser
        self.id = UUID(uuidString: id) ?? UUID()
    }
    
    var dictionary: [String: Any] {
        [
            "content": content,
            "isUser": isUser,
            "createdAt": Date().timeIntervalSince1970
        ]
    }
}
