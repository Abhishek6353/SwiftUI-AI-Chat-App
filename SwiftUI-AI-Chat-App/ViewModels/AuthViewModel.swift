//
//  File.swift
//  SwiftUI-AI-Chat-App
//
//  Created by Apple on 04/09/25.
//

import Foundation
import SwiftUI
import FirebaseAuth

@MainActor
class AuthViewModel: ObservableObject {
    @Published var user: User? = nil
    private var listener: AuthStateDidChangeListenerHandle?
    
    init() {
        listener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.user = user
        }
    }
    
    deinit {
        if let listener = listener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }
    
    var isLoggedIn: Bool {
        return user != nil
    }
    
    func logout() {
        do {
            try AuthServices.shared.logOut()
            self.user = nil  
        } catch {
            print("Error logging out: \(error.localizedDescription)")
        }
    }

}
