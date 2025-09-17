//
//  HomeViewModel.swift
//  SwiftUI-AI-Chat-App
//
//  Created by Apple on 16/09/25.
//
import Foundation
import FirebaseFirestore

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var sessions: [Session] = []
    @Published var isLoading: Bool = false
    
    private let chatService = ChatService()
    private var sessionListener: ListenerRegistration?
    
    init() {
        isLoading = true
        sessionListener = chatService.observeSessions { [weak self] sessions in
            guard let self = self else { return }
            self.sessions = sessions
            self.isLoading = false
        }
    }
    
    deinit {
        sessionListener?.remove()
    }
}
