//
//  ForgotPasswordViewModel.swift
//  SwiftUI-AI-Chat-App
//
//  Created by Apple on 05/09/25.
//

import Foundation

@MainActor
class ForgotPasswordViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var errorMessage: String?

    @Published var isLoading: Bool = false
    @Published var isEmailSent: Bool = false

    
    func resetPassword() async -> Bool {
        errorMessage = ""
        isEmailSent = false
        
        guard !email.isEmpty else {
            errorMessage = "Please enter your email first"
            return false
        }
        
        isLoading = true
        
        do {
            try await AuthServices.shared.resetPassword(email: email)
            isLoading = false
            isEmailSent = true
            return true
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
}
