//
//  LoginViewModel.swift
//  SwiftUI-AI-Chat-App
//
//  Created by Apple on 04/09/25.
//

import Foundation

@MainActor
class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String?
    @Published var isLoggedIn = false
    @Published var isLoading: Bool = false
    
    func login() async {
        errorMessage = nil
        isLoggedIn = false
        
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
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
            let uer = try await AuthServices.shared.logIn(email: trimmedEmail, password: trimmedPassword)
            isLoggedIn = true
            print("✅ User logged in: \(uer.uid)")
        } catch {
            errorMessage = AuthServices.shared.mapFirebaseAuthError(error)
            print("❌ Login failed: \(error)")
        }
        
        isLoading = false
    }
}
