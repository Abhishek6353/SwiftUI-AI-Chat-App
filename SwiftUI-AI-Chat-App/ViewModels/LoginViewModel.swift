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
            let uer = try await AuthServices.shared.logIn(email: email, password: password)
            isLoggedIn = true
            print("✅ User logged in: \(uer.uid)")
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Login failed: \(error)")
        }
        
        isLoading = false
    }
}

