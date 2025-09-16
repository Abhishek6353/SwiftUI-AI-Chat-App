import Foundation
import FirebaseFirestore

struct Session: Identifiable {
    let id: String
    let ownerId: String
    let title: String
    let createdAt: Date?
    let updatedAt: Date?
    let messageCount: Int
    let approxTotalTokens: Int
    let model: String
    let status: String
    
    init?(document: DocumentSnapshot) {
        let data = document.data() ?? [:]
        guard let ownerId = data["ownerId"] as? String,
              let title = data["title"] as? String,
              let messageCount = data["messageCount"] as? Int,
              let approxTotalTokens = data["approxTotalTokens"] as? Int,
              let model = data["model"] as? String,
              let status = data["status"] as? String else {
            return nil
        }
        self.id = document.documentID
        self.ownerId = ownerId
        self.title = title
        self.messageCount = messageCount
        self.approxTotalTokens = approxTotalTokens
        self.model = model
        self.status = status
        if let createdAtTimestamp = data["createdAt"] as? Timestamp {
            self.createdAt = createdAtTimestamp.dateValue()
        } else {
            self.createdAt = nil
        }
        if let updatedAtTimestamp = data["updatedAt"] as? Timestamp {
            self.updatedAt = updatedAtTimestamp.dateValue()
        } else {
            self.updatedAt = nil
        }
    }
}
