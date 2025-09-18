//
//  HomeViewModel.swift
//  SwiftUI-AI-Chat-App
//
//  Created by Apple on 16/09/25.
//
import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var sessions: [Session] = []
    @Published var isLoading: Bool = false
    @Published var userName: String = ""
    
    private let chatService = ChatService()
    private let userService = UserService()
    private var sessionListener: ListenerRegistration?
    
    init() {
        isLoading = true
        sessionListener = chatService.observeSessions { [weak self] sessions in
            guard let self = self else { return }
            self.sessions = sessions
            self.isLoading = false
        }
        
        // Fetch user name
        Task {
            if let uid = Auth.auth().currentUser?.uid {
                if let user = try? await userService.fetchUserProfile(uid: uid) {
                    self.userName = user.name
                }
            }
        }
    }
    
    deinit {
        sessionListener?.remove()
    }
}
