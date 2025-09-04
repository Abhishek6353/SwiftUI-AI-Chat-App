//
//  SignupViewModel.swift
//  SwiftUI-AI-Chat-App
//
//  Created by Apple on 04/09/25.
//

import Foundation

@MainActor
final class SignupViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String?
    @Published var isSignedUp = false
    @Published var isLoading: Bool = false
    
    
    func signUp() async {
        
        errorMessage = nil
        isSignedUp = false
        
        guard !name.isEmpty, !email.isEmpty, !password.isEmpty else {
            errorMessage = "All fields are required"
            return
        }
        
        isLoading = true
        
        do {
            let user = try await AuthServices.shared.signUp(email: email, password: password)
            try await UserService().saveUserProfile(uid: user.uid, name: name, email: email)
            isSignedUp = true
            print("✅ User created & profile saved for \(user.uid)")
            
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Signup failed: \(error)")
        }
        
        isLoading = false
    }
}
