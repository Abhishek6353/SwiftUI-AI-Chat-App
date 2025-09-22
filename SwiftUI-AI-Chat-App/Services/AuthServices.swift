//
//  AuthServices.swift
//  SwiftUI-AI-Chat-App
//
//  Created by Apple on 04/09/25.
//

import Foundation
import FirebaseAuth

final class AuthServices {
    
    static let shared = AuthServices()
    
    private init() {}
    
    // MARK: - Sign Up
    func signUp(email: String, password: String) async throws -> User {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        return result.user
    }
    
    // MARK: - Login
    func logIn(email: String, password: String) async throws -> User {
        if Auth.auth().currentUser != nil {
            try await logOut()
        }
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return result.user
    }
    
    // MARK: - Reset Password
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    // MARK: - Logout
    func logOut() throws {
        try Auth.auth().signOut()
    }
    
    // MARK: - Current User
    func currentUser() -> User? {
        return Auth.auth().currentUser
    }
    
    // MARK: - Error Mapping
    func mapFirebaseAuthError(_ error: Error) -> String {
        if let err = error as NSError? {
            switch err.code {
            case AuthErrorCode.invalidEmail.rawValue:
                return "The email address is badly formatted."
            case AuthErrorCode.userNotFound.rawValue:
                return "No user found with this email."
            case AuthErrorCode.wrongPassword.rawValue:
                return "Incorrect password. Please try again."
            case AuthErrorCode.emailAlreadyInUse.rawValue:
                return "This email is already in use."
            case AuthErrorCode.weakPassword.rawValue:
                return "Password is too weak."
            case AuthErrorCode.networkError.rawValue:
                return "Network error. Please check your connection."
            case AuthErrorCode.userDisabled.rawValue:
                return "This account has been disabled."
            case AuthErrorCode.tooManyRequests.rawValue:
                return "Too many attempts. Please try again later."
            case AuthErrorCode.invalidCredential.rawValue:
                return "The supplied credentials are invalid or have expired."
            default:
                return err.localizedDescription
            }
        }
        return error.localizedDescription
    }
}
