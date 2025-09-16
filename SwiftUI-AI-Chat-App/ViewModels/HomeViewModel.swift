//
//  HomeViewModel.swift
//  SwiftUI-AI-Chat-App
//
//  Created by Apple on 16/09/25.
//
import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var sessions: [Session] = []
    @Published var isLoading: Bool = false
    
    private let chatService = ChatService()
    
    init() {
        Task {
            await fetchSessions()
        }
    }
    
    func fetchSessions() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            self.sessions = try await chatService.fetchSessions()
        } catch {
            print("❌ Error fetching sessions: \(error.localizedDescription)")
        }
    }
}
