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
        
        guard !email.isEmpty else {
            errorMessage = "Email is required."
            return
        }
        guard InputValidator.isValidEmail(email) else {
            errorMessage = "Please enter a valid email address."
            return
        }
        guard !password.isEmpty else {
            errorMessage = "Password is required."
            return
        }
        guard InputValidator.isValidPassword(password) else {
            errorMessage = "Password must be at least 8 characters, include uppercase, lowercase, digit, and special character."
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
