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
        
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedEmail.isEmpty else {
            errorMessage = "Email is required."
            return
        }
        guard InputValidator.isValidEmail(trimmedEmail) else {
            errorMessage = "Please enter a valid email address."
            return
        }
        guard !trimmedPassword.isEmpty else {
            errorMessage = "Password is required."
            return
        }
        guard InputValidator.isValidPassword(trimmedPassword) else {
            errorMessage = "Password must be at least 8 characters, include uppercase, lowercase, digit, and special character."
            return
        }
        
        isLoading = true
        
        do {
            let user = try await AuthServices.shared.signUp(email: trimmedEmail, password: trimmedPassword)
            try await UserService().saveUserProfile(uid: user.uid, name: trimmedName, email: trimmedEmail)
            isSignedUp = true
            print("✅ User created & profile saved for \(user.uid)")
            
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Signup failed: \(error)")
        }
        
        isLoading = false
    }
}
